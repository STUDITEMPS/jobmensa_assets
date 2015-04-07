module JobmensaAssets
  class Railtie < Rails::Railtie

    initializer 'jobmensa_assets.configure'
      require 'jobmensa_assets/config'
    end

  end
end