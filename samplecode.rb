{\rtf1\ansi\ansicpg932\cocoartf1404\cocoasubrtf470
{\fonttbl\f0\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\sl280\partightenfactor0

\f0\fs24 \cf0 \expnd0\expndtw0\kerning0
require 'rubygems'\
require 'bundler'\
Bundler.require\
\
class HRMonitorApp < Sinatra::Base\
  configure do\
    use OmniAuth::Builder do\
      provider :fitbit_oauth2, '#\{227X9M\}','#\{0028e2ae17d2c207903a5f92f996869e\}',\
      scope: 'profile',\
      expires_in: '2592000'\
    end\
    enable :sessions\
    enable :inline_templates\
    set :bind, '0.0.0.0'\
    set :port, 3000\
  end\
\
  helpers do\
    def get_profile\
      res = JSON.parse RestClient.get "https://api.fitbit.com/1/user/-/profile.json", Authorization: "Bearer #\{session[:token]\}"\
      warn "#\{res\}"\
      "<body><h1><code>#\{res\}</code></h1></body>"\
    rescue => e\
      warn e\
    end\
  end\
\
  get '/' do\
    if session[:token]\
      get_profile\
    else\
      redirect to '/auth/fitbit_oauth2'\
    end\
  end\
\
  get '/auth/fitbit_oauth2/callback' do\
    session[:token] = env['omniauth.auth']['credentials'].token\
    redirect to '/'\
  end\
end\
\
HRMonitorApp.run!\
}