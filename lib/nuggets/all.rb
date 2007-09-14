Dir[__FILE__.sub(/\.rb\z/, '/**/*.rb')].sort.each { |rb|
  require rb
}
