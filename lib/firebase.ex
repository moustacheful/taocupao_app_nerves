defmodule Firebase do
  use HTTPoison.Base

  # Currently unused
  def generate_token do
    email = Application.get_env(:taocupao_app_nerves, :firebase_service_account_email)
    now = System.system_time(:second)

    payload = %{
      iss: email,
      sub: email,
      uid: "taocupao-app",
      aud: Application.get_env(:taocupao_app_nerves, :firebase_slug),
      iat: now,
      exp: now + 3600
    }

    secret =
      Application.get_env(:taocupao_app_nerves, :firebase_pem)
      |> JsonWebToken.Algorithm.RsaUtil.private_key()

    JsonWebToken.sign(payload, %{
      alg: "RS256",
      key: secret
    })
  end

  def process_request_url(url) do
    slug = Application.get_env(:taocupao_app_nerves, :firebase_slug)

    # token = generate_token()
    "https://#{slug}.firebaseio.com" <> url
    # <> "?access_token=#{token}"
  end
end
