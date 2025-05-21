
# Install ruby using rbenv
ruby_version=`cat .ruby-version`
if [[ ! -d "$HOME/.rbenv/versions/$ruby_version" ]]; then
  rbenv install $ruby_version;
fi
# Install bunlder {#install-bunlder  data-source-line="89"}
gem install bundler
# Install all gems {#install-all-gems  data-source-line="91"}
bundle install
# Install all pods {#install-all-pods  data-source-line="93"}
bundle exec pod install
