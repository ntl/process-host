require_relative '../automated_init'

context "Channel Value" do
  context "Serialization" do
    context "Boolean" do
      fixture(Fixtures::Value, true, transfer_size_bytes: 1)
      fixture(Fixtures::Value, false, transfer_size_bytes: 1)
    end
  end
end
