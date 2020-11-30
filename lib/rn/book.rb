module RN
    class Book
        attr_accessor :name

        def create(name)
            if ! Dir.exist?(Dir.home + "/.my_rns/" + name)
                Dir.mkdir(File.join(Dir.home, ".my_rns/" + name), 0700)
                message={"message"=>"El cuaderno #{name.inspect} fue creado con éxito!", "type"=>"ok"}
            else
                message={"message"=>"Ya existe un cuaderno llamado #{name.inspect}", "type"=>"error"}
            end
            return message
        end

        def delete(name)
            message={'message'=> "El cuaderno #{name} fue borrado con éxito!", 'type'=>'ok'}
            if name == "global"
                path = Dir.home + "/.my_rns"
                Dir.glob("#{path}/*").each do |f|
                    FileUtils.rm f unless File.directory? f
                end
            else
                begin
                    if Dir.exist?(Dir.home + "/.my_rns/" + name)          
                        FileUtils.remove_dir(Dir.home + "/.my_rns/" + name)
                    else
                        message={"message"=> "No existe un cuaderno cuyo nombre sea #{name}", 'type'=>'error'}
                    end
                rescue 
                    message={'message'=>'Ingrese un nombre válido o la opción --global', 'type'=> 'error'}
                end
            end
            return message
        end

        def list
            Dir.chdir(Dir.home + "/.my_rns/")
            cuaderno = Dir.glob('*').select {|f| File.directory? f}
            cuaderno.each {|book| p book, :rainbow}
        end

        def rename(old_name, new_name)
            if Dir.exist?(Dir.home + "/.my_rns/" + old_name)
                if !Dir.exist?(Dir.home + "/.my_rns/" + new_name)
                    File.rename(Dir.home+"/.my_rns/"+ old_name, Dir.home + "/.my_rns/" + new_name)
                    status={"message"=>"El cuaderno #{old_name} fue renombrado a #{new_name} con éxito!", "type"=>"ok"}
                else
                    status={"message"=>"El cuaderno #{old_name} no fue renombrado a #{new_name}, ya que ya existe un cuaderno nombrado así", "type"=>"error"}
                end
            else
                status={"message" => "No existe un cuaderno cuyo nombre sea #{old_name}", "type" => "error"}
            end
            return status
        end
    end 
end