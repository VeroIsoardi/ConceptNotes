require 'commonmarker'
html=""
if File.exist?("#{Dir.home}/.my_rns/hola.rn")
    File.foreach("#{Dir.home}/.my_rns/hola.rn") do |line|
        html << CommonMarker.render_html(line, :DEFAULT, [:table, :tasklist, :strikethrough, :autolink, :tagfilter])        
    end
    puts html
    File.write(Dir.home+'/Documents/hola.html', html)
end

