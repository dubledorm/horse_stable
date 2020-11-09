module Substitutions
  class PhoneNumber < Base
    include ActiveModel::Model

    PHONE_PREFIX = %w(916 499 495 826 915 800 910 812)
    PHONE_FORMATS = { short_8: '8DDDDDDDDDD',
                      short_7: '+7DDDDDDDDDD',
                      brackets_8: '8(DDD)DDDDDDD',
                      brackets_7: '+7(DDD)DDDDDDD',
                      spaces_8: '8 DDD DDD DD DD',
                      spaces_7: '+7 DDD DDD DD DD',
                      spaces_b_8: '8 (DDD) DDD DD DD',
                      spaces_b_7: '+7 (DDD) DDD DD DD',
                      spaces_d_8: '8-DDD-DDD-DD-DD',
                      spaces_d_7: '+7-DDD-DDD-DD-DD',
                      spaces_db_8: '8(DDD)DDD-DD-DD',
                      spaces_db_7: '+7(DDD)DDD-DD-DD',
                      free: ''
    }

    attr_accessor :sequence, :format
    validates :sequence, inclusion: { in: %w(random list),
                                      message: "%{value} is not a valid sequence" }
    validates :format, inclusion: { in: PHONE_FORMATS.stringify_keys.keys,
                                      message: "%{value} is not a valid strict" }


    def initialize(hash_attributes = {})
      super(hash_attributes)
      @sequence = 'random' unless @sequence.present?
      @format = 'free' unless @format.present?
    end

    def human_description
      'Возвращает телефонный номер. Параметры: '
    end

    def calculate
      case @sequence
      when 'random'
        number_arr = random
      when 'list'
        number_arr = list
      else
        raise ArgumentError, 'Неизвестное значение параметра sequence'
      end

      case @format.to_sym
      when :free
        phone_format = PHONE_FORMATS.select{ |key, value| key != :free }.values[Random.rand(PHONE_FORMATS.count - 1)]
      else
        phone_format = PHONE_FORMATS[@format.to_sym]
      end

      phone_format.chars.each.map{ |smb| smb == 'D' ? number_arr.shift : smb }.join('')
    end

    private

    def random
      prefix = PHONE_PREFIX[Random.rand(PHONE_PREFIX.count)]
      number = (1..7).to_a.map{ |num| Random.rand(9) }.join('')
      "#{prefix}#{number}".chars
    end

    def list
      raise NotImplementedError
    end
  end
end