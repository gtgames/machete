
task :lessc do
  `which lessc`
  if $?.to_i == 0
    Dir['**/layout.less'].each do |f|
      sh 'lessc', f, f.sub(/less$/, 'css')
    end
  else
    puts "lessc not found, install it with npm"
  end
end

