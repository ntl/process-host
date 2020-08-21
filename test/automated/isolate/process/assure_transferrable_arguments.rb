require_relative '../../automated_init'

context "Isolate" do
  context "Process" do
    context "Assure Transferrable Arguments" do
      context "Transferrable" do
        [
          Controls::Argument::Transferrable.nil,
          Controls::Argument::Transferrable.true,
          Controls::Argument::Transferrable.false,
          Controls::Argument::Transferrable.integer,
          Controls::Argument::Transferrable.float,
          Controls::Argument::Transferrable.symbol,
          Controls::Argument::Transferrable.string,
          Controls::Argument::Transferrable.array,
          Controls::Argument::Transferrable.hash,
          Controls::Argument::Transferrable.mutex,
          Controls::Argument::Transferrable.queue
        ].each do |argument|
          context "Argument: #{argument.inspect}" do
            test "Is not an error" do
              refute_raises(ProcessHost::Isolate::Process::ArgumentError) do
                ProcessHost::Isolate::Process.assure_transferrable(argument)
              end
            end
          end
        end
      end

      context "Non Transferrable" do
        context "Object" do
          argument = Controls::Argument::NonTransferrable.example

          test "Is an error" do
            assert_raises(ProcessHost::Isolate::Process::ArgumentError) do
              ProcessHost::Isolate::Process.assure_transferrable(argument)
            end
          end
        end

        context "Array With Object" do
          argument = [Controls::Argument::NonTransferrable.example]

          test "Is an error" do
            assert_raises(ProcessHost::Isolate::Process::ArgumentError) do
              ProcessHost::Isolate::Process.assure_transferrable(argument)
            end
          end
        end

        context "Hash With Object" do
          argument = {
            :some_key => Controls::Argument::NonTransferrable.example
          }

          test "Is an error" do
            assert_raises(ProcessHost::Isolate::Process::ArgumentError) do
              ProcessHost::Isolate::Process.assure_transferrable(argument)
            end
          end
        end

        context "Deep Nested Hash" do
          argument = {
            :some_key => [
              { :other_key => Controls::Argument::NonTransferrable.example }
            ]
          }

          test "Is an error" do
            assert_raises(ProcessHost::Isolate::Process::ArgumentError) do
              ProcessHost::Isolate::Process.assure_transferrable(argument)
            end
          end
        end
      end

      context "Multiple Arguments" do
        context "All Are Transferrable" do
          arguments = [
            Controls::Argument::Transferrable.example,
            Controls::Argument::Transferrable.example
          ]

          test "Is not an error" do
            refute_raises(ProcessHost::Isolate::Process::ArgumentError) do
              ProcessHost::Isolate::Process.assure_transferrable(*arguments)
            end
          end
        end

        context "Some Are Non-Transferrable" do
          arguments = [
            Controls::Argument::Transferrable.example,
            Controls::Argument::NonTransferrable.example
          ]

          test "Is an error" do
            assert_raises(ProcessHost::Isolate::Process::ArgumentError) do
              ProcessHost::Isolate::Process.assure_transferrable(*arguments)
            end
          end
        end

        context "None Are Transferrable" do
          arguments = [
            Controls::Argument::NonTransferrable.example,
            Controls::Argument::NonTransferrable.example
          ]

          test "Is an error" do
            assert_raises(ProcessHost::Isolate::Process::ArgumentError) do
              ProcessHost::Isolate::Process.assure_transferrable(*arguments)
            end
          end
        end
      end
    end
  end
end
