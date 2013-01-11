require 'nacl'
require 'scrypt'
require 'securerandom'
require 'yaml'

require 'vinz/version'

class VINZ
  DIR = File.expand_path(File.join(File.dirname(__FILE__), '..'))
end

$: << "#{VINZ::DIR}/lib" unless $:.include?("#{VINZ::DIR}/lib")

class Vinz
  attr_writer :password
  attr_accessor :vaultfile
  attr_accessor :noncefile
  attr_accessor :saltfile
  attr_accessor :vault
  attr_accessor :plaintext
  attr_accessor :ciphertext

  def initialize(vaultfile=nil, noncefile=nil, saltfile=nil)
    @vaultfile = vaultfile || File.join(Dir.home, ".vinzdb")
    @noncefile = noncefile || File.join(Dir.home, ".vinznonce")
    @saltfile = saltfile || File.join(Dir.home, ".vinzsalt")
    @ciphertext = nil
    @plaintext = nil
    @password = 'secretpassword'
    @nonce = nil
    load
  end

  def add(key, data)
    @vault[key] = data
  end

  def lookup(key)
    @vault[key]
  end

  def load
    begin
      @ciphertext = open(@vaultfile).read # if File.exist?(@vaultfile)
      @nonce = open(@noncefile, 'rb').read # if @ciphertext
      @salt = open(@saltfile, 'rb').read # if @ciphertext
      puts "ciphertext: #{@ciphertext.unpack("H*")}"
      puts "nonce: #{@nonce}"
      puts "salt: #{@salt}"
    rescue => e
      puts "[x] Error loading vault: #{e}"
      puts "    vaultfile: #{@vaultfile}"
      puts "    noncefile: #{@noncefile}"
      puts "    saltfile: #{@saltfile}"
    end
    return unless @ciphertext && @nonce && @salt

    #begin
      password = SCrypt::Engine.hash_secret(@password, @salt)
      puts "Password: #{password}"
      pwsplit = password.split('$')
      salt = [pwsplit[3]].pack("H*")
      hash = [pwsplit[4]].pack('H*')
      @plaintext = NaCl.crypto_secretbox_open(@ciphertext, @nonce, hash)
      puts "plaintext: #{@plaintext}"
      @vault = YAML::load(@plaintext)
      puts "vault: #{@vault}"
      return true
    #rescue => e
    #  puts "Error parsing ciphertext: #{e}"
    #end
    @vault = nil
    false
  end

  def save
    @vault ||= {}
    password = SCrypt::Password.create(@password)
    salt = password.split('$')[0..3].join('$')
    hash = [password.hash].pack('H*')
    puts "salt: #{salt}"
    puts "Password: #{password}"
    @nonce = SecureRandom.random_bytes(NaCl::BOX_NONCE_LENGTH)
    @ciphertext = NaCl::crypto_secretbox(@vault.to_yaml, @nonce, hash)
    #begin
      open(@noncefile, 'wb') { |nf| nf << @nonce}
      open(@saltfile, 'wb') { |nf| nf << salt}
      open(@vaultfile, "wb") { |vf| vf << @ciphertext }
      return true
    #rescue => e
    #  puts "[x] Error saving #{@vaultfile}: #{e}"
    #end
    false
  end
end
