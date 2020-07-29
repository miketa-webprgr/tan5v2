require "rails_helper"

describe 'user show page', type: :system do

  describe '単語帳作成' do
    before do
      @user_a = FactoryBot.create(:user, name: "taro", email: "example@mail.com", profile: "this is profile")
      #FactoryBot.create(:wordnote, name: "sample", subject: "English", user: user_a)
      visit login_path 
      password = "password"
      fill_in 'メールアドレス' , with: @user_a.email
      fill_in 'パスワード' , with: password
      click_button 'ログイン'

    end
    context 'ユーザーA' do
      example '初期画面が正しく表示されている' do
        expect(page).not_to have_content '作成した単語帳'
        p tmp = find(:xpath, '//*[@class="user-name"]/h1').text
        expect(tmp).to have_content @user_a.name
        p tmp = find(:xpath, '//*[@class="user-profile"]').text
        expect(tmp).to have_content @user_a.profile
        p tmp = find(:xpath, '//*[@class="user-created_at"]').text
        expect(tmp).to have_content @user_a.created_at.to_s.split(" ").first
      end

      example '単語帳を登録' do
        fill_in 'wordnote_name', with: "sample"
        fill_in 'wordnote_subject', with: "English"
        click_button '登録'
        sleep 1
        expect(page).to have_content '作成した単語帳'
        expect(page).to have_content "sample"
        expect(page).to have_content "English"
        expect(page).to have_content "単語を登録"
        
      end
      example '単語を登録' do
        FactoryBot.create(:wordnote, name: "sample", subject: "English", user: @user_a)
        fill_in 'tango_question', with: "お腹が空いた"
        fill_in 'tango_answer', with: "hungry"
        click_button '単語を登録'
        sleep 1
        tmp = find(:xpath, '//*[@id="categories"]/table/tbody/tr[2]/td[3]').text
        expect(tmp).to eq("1")
        
      end
    end
  end


end
