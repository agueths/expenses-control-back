class Tokenization
  include ActiveModel::Model

  def self.encode(payload)
    timenow = Time.now.to_i
    JWT.encode(
      payload.merge(
        {
          exp: (timenow + 4 * 3600),
          iat: timenow,
          jti: Digest::MD5.hexdigest(
            [
              Rails.application.credentials[:jwt_secret_key],
              timenow
            ].join(':').to_s
          )
        }
      ),
      Rails.application.credentials[:jwt_secret_key],
      'HS512'
    )
  end

  def self.decode(token)
    {
      error: false,
      payload: JWT.decode(
        token,
        Rails.application.credentials[:jwt_secret_key],
        true, {
          verify_expiration: true, verify_iat: true, verify_jti: true, algorithm: 'HS512'
        }
      )[0]
    }
  rescue JWT::ExpiredSignature
    {
      error: true,
      command: 'tokenization_decode',
      raised: 'expired_signature'
    }
  rescue JWT::InvalidIatError
    {
      error: true,
      command: 'tokenization_decode',
      raised: 'invalid_iat'
    }
  rescue JWT::InvalidJtiError
    {
      error: true,
      command: 'tokenization_decode',
      raised: 'invalid_jti'
    }
  end
end
