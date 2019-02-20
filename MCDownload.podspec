Pod::Spec.new do |s|
    s.name             = "MCDownload"
    s.version          = "0.0.1"
    s.summary          = "MCDownload support File download"
    s.description      = "MCDownload support File download."
    s.license          = 'MIT'
    s.author           = { "littleplayer" => "mailjiancheng@163.com" }
    s.homepage         = "https://github.com/poholo/MCDownload"
    s.source           = { :git => "https://github.com/poholo/MCDownload.git", :tag => s.version.to_s }

    s.platform     = :ios, '8.0'
    s.requires_arc = true


    s.source_files = 'SDK/*.{h,m,mm}',
                     'SDK/**/*.{h,m,mm}'
    s.public_header_files = 'SDK/*.h',
                            'SDK/**/*.h'

end