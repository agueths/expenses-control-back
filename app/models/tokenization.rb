class Tokenization
  include ActiveModel::Model

  def self.encode(payload)
    timenow = Time.now.to_i
    JWT.encode(
      {
        exp: (timenow + 4 * 3600),
        iat: timenow,
        jti: Digest::MD5.hexdigest(
          [
            Rails.application.credentials.jwt_secret_key,
            timenow
          ].join(':').to_s
        ),
        data: payload
      },
      Rails.application.credentials.jwt_secret_key,
      'HS512'
    )
  end

  def self.decode(token)
    jwt_ret = JWT.decode(
      token,
      Rails.application.credentials.jwt_secret_key,
      true,
      {
        verify_iat: true, verify_jti: true, algorithm: 'HS512'
      }
    )[0]
    {
      error: false,
      payload: jwt_ret['data']
    }
  rescue JWT::ExpiredSignature => e
    {
      error: true,
      command: 'tokenization_decode',
      raised: 'expired_signature',
      message: e
    }
  rescue JWT::InvalidIatError => e
    {
      error: true,
      command: 'tokenization_decode',
      raised: 'invalid_iat',
      message: e
    }
  rescue JWT::InvalidJtiError => e
    {
      error: true,
      command: 'tokenization_decode',
      raised: 'invalid_jti',
      message: e
    }
  rescue JWT::DecodeError => e
    {
      error: true,
      command: 'tokenization_decode',
      raised: 'decode_error',
      message: e
    }
  end
end
