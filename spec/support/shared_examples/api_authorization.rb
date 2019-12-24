shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if the is no access_token' do
      do_request(method, api_path, headers: headers)

      expect(response.status).to eq 401
    end
    it 'returns 401 status if access_token is invalid' do
      options = {params: { access_token: '1234' }, headers: headers}
      # options[:params] = options[:params].merge(add_attr) if add_attr
      do_request(method, api_path, options)

      expect(response.status).to eq 401
    end
  end

  context 'authorized' do

    it 'returns 200 status' do
      do_request(method, api_path, req_options)

      expect(response).to be_successful
    end
  end
end