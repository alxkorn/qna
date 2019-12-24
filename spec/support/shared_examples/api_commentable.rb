shared_examples_for 'API Commentable' do

  let(:resource_response) { json[resource.type] }

  let!(:comments) { create_list(:comment, 2, commentable: resource) }
  let(:first_comment) { resource.comments.first }

  let(:first_response_comment) { resource_response['comments'].find{|c| c['id'] == first_comment.id} }

  before do
    get api_path, params: { access_token: access_token.token }, headers: headers
  end

  context 'comments' do
    it "returns all resource's comments" do
      expect(resource_response['comments'].size).to eq resource.comments.size
    end

    it "return's comment public fields" do
      %w[id body created_at updated_at user_id].each do |attr|
        expect(first_response_comment[attr]).to eq first_comment.send(attr).as_json
      end
    end
  end
end