shared_examples_for 'API Linkable' do
  
  let(:resource_response) { json[resource.type] }

  let!(:links) { create_list(:link, 2, linkable: resource) }
  let(:first_link) { links.first }
  let(:first_response_link) { resource_response['links'].find{|c| c['id'] == first_link.id} }

  before do
    get api_path, params: { access_token: access_token.token }, headers: headers
  end

  context 'links' do
    it "returns all question's links" do
      expect(resource_response['links'].size).to eq resource.links.size
    end

    it "return's link public fields" do
      %w[id name url created_at updated_at].each do |attr|
        expect(first_response_link[attr]).to eq first_link.send(attr).as_json
      end
    end
  end
end