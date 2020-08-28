class ProcessHost
  module Fixtures
    class Value
      include TestBench::Fixture

      attr_reader :input
      attr_reader :transfer_size

      def initialize(input, transfer_size)
        @input, @transfer_size = input, transfer_size
      end

      def self.build(input, transfer_size_bytes:)
        new(input, transfer_size_bytes)
      end

      def call
        context "Value: #{input.inspect}" do
          context "Dump and Load" do
            value = ProcessHost::Channel::Value.new(input)

            detail "Raw Data: #{value.raw.inspect} (#{value.size} bytes)"

            context "Restore Value" do
              previous_bytes_transferred = ProcessHost::Channel::Value.bytes_transferred

              restored_value = value.restore

              test "Input value is restored" do
                detail "Control Value: #{input.inspect}"
                detail "Compare Value: #{restored_value.inspect}"

                assert(restored_value == input)
              end

              test "Byte transfer count" do
                control_bytes_transferred = previous_bytes_transferred + transfer_size

                detail "Previous Bytes Transferred: #{previous_bytes_transferred}"
                detail "Control Bytes Transferred: #{control_bytes_transferred}"

                bytes_transferred = ProcessHost::Channel::Value.bytes_transferred

                detail "Bytes Transferred: #{bytes_transferred}"

                assert(bytes_transferred == control_bytes_transferred)
              end
            end
          end
        end
      end
    end
  end
end
