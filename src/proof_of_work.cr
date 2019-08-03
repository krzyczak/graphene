require "openssl"

module Graphene
  class ProofOfWork
    def self.mine(data)
      new(data: data).mine
    end

    def initialize(@data : String, @nonce = 0)
    end

    def mine(difficulty = "00")
      while (hash_with_nonce(@nonce))[0..(difficulty.size - 1)] != difficulty
        @nonce += 1
      end
      {nonce: @nonce, hash: hash_with_nonce(@nonce)}
    end

    private def hash_with_nonce(nonce)
      OpenSSL::Digest.new("SHA256").update("#{nonce}#{@data}").hexdigest
    end
  end
end
