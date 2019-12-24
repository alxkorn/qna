shared_examples_for 'API Attachable' do
  
  let(:resource_response) { json[resource.type] }

  let!(:files) { resource.files }
  let(:first_response_file) { resource_response['files'].first }

  before do
    get api_path, params: { access_token: access_token.token }, headers: headers
  end

  context 'files' do
    it "returns all question's files" do
      expect(resource_response['files'].size).to eq resource.files.size
    end

    it 'returns url' do
      expect(first_response_file).to have_key('url')
    end
  end
 
end