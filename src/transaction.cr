require "json"

module Graphene
  class Transaction
    property from : String
    property to : String
    property amount : Int32

    def initialize(@from, @to, @amount)
    end

    def to_json(json : JSON::Builder)
      json.object do
        json.field("from", @from)
        json.field("to", @to)
        json.field("amount", @amount)
      end
    end
  end
end
