Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '641936765942733', '499d8ac574c247f61b17f05dd8fb74db',
  :scope => 'public_profile, email, user_friends,'
end