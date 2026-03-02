require 'yaml'

class Algoritmam
  def initialize
    # HATA 1 DÜZELTİLDİ: verileri_yukle metodu veriyi döndürür, biz @veriler'e atarız.
    @veriler = verileri_yukle 
    
    # Hangi gündeyiz?
    @secilen_gun = gunu_sec
    puts "📅 Bugün: #{@secilen_gun.capitalize}" # Kullanıcı bilsin
    sleep(1)

    # HATA 2 DÜZELTİLDİ: Gün verisi yoksa patlamayı önle (Guard Clause)
    if @veriler.key?(@secilen_gun)
      @gun_verisi = @veriler[@secilen_gun]
      @aktif_adim_id = @gun_verisi["baslangic"]
    else
      puts "🚫 Üzgünüm, '#{@secilen_gun}' günü için henüz bir akış planlanmamış."
      puts "🛠️ Lütfen sorular.yml dosyasını düzenle."
      exit # Programı burada güvenli şekilde kapat.
    end
  end

  def baslat
    while @aktif_adim_id
      ekrani_temizle
      adim_verisi = @gun_verisi[@aktif_adim_id] 

      if adim_verisi.key?("sonuc")
        # İYİLEŞTİRME 3: Sonucu gösterince hemen kapanmasın.
        puts "\n🎉 SONUÇ:"
        puts ">> #{adim_verisi['sonuc']} <<\n"
        puts "\n(Çıkmak için Enter'a bas...)"
        gets
        break
      else
        # Soru Sorma Kısmı
        puts "❓ Soru: #{adim_verisi['metin']}"
        print "Cevap (e/h) > " # Kullanıcı nereye yazacağını görsün
        
        cevap = gets.chomp.downcase.strip
        
        if cevap == "e" || cevap == "evet"
          @aktif_adim_id = adim_verisi["evet"]
        elsif cevap == "h" || cevap == "hayir"
          @aktif_adim_id = adim_verisi["hayir"]
        else
          puts "⚠️ Lütfen sadece 'e' veya 'h' ile cevap verin."
          sleep(2) # Senin eklediğin harika UX çözümü
        end
      end
    end
  end
  private
  def ekrani_temizle
    system("clear") || system("cls")
  end
  def gunu_sec
    t = Time.now
    gunler = %w(pazar pazartesi sali carsamba persembe cuma cumartesi)
    secilen_gun = gunler[t.wday]
    return secilen_gun
  end
  def verileri_yukle
    if File.exist?('sorular.yml')
      YAML.load_file('sorular.yml')
    else
      # Dosya yoksa kullanıcıyı uyaralım
      puts "🔥 HATA: 'sorular.yml' dosyası bulunamadı!"
      exit
    end
  end
end

algoritmam = Algoritmam.new
algoritmam.baslat
