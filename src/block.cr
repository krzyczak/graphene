require "openssl"
require "json"

require "./transaction"
require "./proof_of_work"

module Graphene
  class Block
    # @timestamp : Int64

    getter :index, :nonce, :current_hash

    def initialize(@index = 0, @transactions = [] of Graphene::Transaction, @previous_hash = "genesis", pow = Graphene::ProofOfWork)
      # @timestamp = Time.now.to_unix
      @timestamp = 100_u64
      pow = pow.mine("#{@index}#{@timestamp}#{@transactions.to_json}#{@previous_hash}")
      @nonce = pow[:nonce].as(Int32)
      @current_hash = pow[:hash].as(String)
    end

    def self.next(previous, transactions = [] of Graphene::Transaction)
      new(
        transactions: transactions,
        index: previous.index + 1,
        previous_hash: previous.current_hash
      )
    end

    def to_s
      "@index = #{@index}\n@transactions = #{@transactions}\n@previous_hash = #{@previous_hash}\nhash = #{current_hash}\nnonce = #{nonce}"
    end
  end
end

def print_block(block)
  puts "\n--------- BLOCK #{block.index} ---------------------------------"
  puts block.current_hash
  puts block.to_s
  puts "---------------------------------------------------\n"
end

blockchain = [Graphene::Block.new]

2.times do |index|
  transactions = [Graphene::Transaction.new("asd", "zxc", 100)]
  block = Graphene::Block.next(blockchain[index], transactions)
  print_block(block)
  blockchain << block
end

# require "benchmark"

# Benchmark.ips do |x|
#   x.report("----- ProofOfWork") { Graphene::ProofOfWork.new("data").mine }
#   x.report("-----         PoW") { Graphene::PoW.mine("data") }
# end
