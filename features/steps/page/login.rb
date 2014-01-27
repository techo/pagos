# encoding: utf-8

module Page
  class Login < Base
    def initialize(email, password)
      @email = email
      @password = password
    end

    def login
      visit new_user_session_path
      fill_form
      submit
    end

    def login_success?
      page.has_content?('Has iniciado sesión correctamente.')
    end

    private
    def fill_form
      fill_in "Correo electrónico:", with: @email
      fill_in "Contraseña:", with: @password
    end

    def submit
      click_button "Entrar"
    end
  end
end