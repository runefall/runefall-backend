RSpec.describe "Test" do
  describe '#test_name' do
    it 'confirms that CI works - bad tests' do
      expect(2+2).to eq("banana")
      expect("string").to be_a(Array)
    end

    it 'confirms that CI works - good tests' do
      expect(2+2).to eq(4)
      expect("string").to be_a(String)
    end
  end
end