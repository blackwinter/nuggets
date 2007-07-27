Dir.glob(__FILE__.sub(/\.rb$/, '/**/*.rb').sort.each { |rb|
  require rb
}
