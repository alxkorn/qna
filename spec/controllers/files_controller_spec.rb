require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'owned file' do
      let!(:answer) { create(:answer, :with_attached_file, user: user) }
      let!(:question) { create(:question, :with_attached_file, user: user) }

      it 'deletes file' do
        expect { delete :destroy, params: { id: answer.files.first, format: :js } }.to change(answer.files, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer.files.first, format: :js }

        expect(response).to render_template :destroy
      end

    end

    context 'not owned file' do
      let!(:answer) { create(:answer, :with_attached_file) }

      it 'does not delete file' do
        expect { delete :destroy, params: { id: answer.files.first, format: :js } }.to_not change(answer.files, :count)
      end

      it 'responds with forbidden' do
        delete :destroy, params: { id: answer.files.first, format: :js }

        expect(response.status).to eq 403
      end
    end
  end

end
