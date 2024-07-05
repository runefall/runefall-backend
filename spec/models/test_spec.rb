RSpec.describe "Test" do
  describe '#test_name' do
    it 'confirms that CI works' do
      expect(2+2).to eq(4)
      expect("string").to be_a(String)
    end
  end
end