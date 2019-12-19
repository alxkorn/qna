RSpec.shared_examples 'Commentable' do |resource_type|
  let!(:resource) { create(resource_type) }
  describe 'type' do
    it 'returns downcased class name of commentable' do
      expect(resource.type).to eq resource.class.to_s.downcase
    end
  end
end