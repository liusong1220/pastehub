#
# config.rb - PasteHub's config file loader and config object.
#  
#   Copyright (c) 2009-2011  Kiyoka Nishiyama  <kiyoka@sumibi.org>
#   
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions
#   are met:
#   
#   1. Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#  
#   2. Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#  
#   3. Neither the name of the authors nor the names of its contributors
#      may be used to endorse or promote products derived from this
#      software without specific prior written permission.
#  
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
#   TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
#   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
#   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
#   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#  
#
require 'singleton'
require 'json'

module PasteHub
  class Config
    include Singleton

    def self.instance
      @@instance ||= new
    end

    def initialize( )
      self.setupClient( {} )
    end

    def getHomeDirectory( )
      if ENV[ 'HOME' ]
        return ENV[ 'HOME' ]
      else
        return "~/"
      end
    end

    def setupClient( hash )
      @localDbPath         = if hash[ :localDbPath ]
                               hash[ :localDbPath ]
                             else
                               File.expand_path( sprintf( "%s/.pastehub/", getHomeDirectory() ))  + "/"
                             end
      @localSyncPath       = if hash[ :localSyncPath ]
                               hash[ :localSyncPath ]
                             else
                               File.expand_path( sprintf( "%s/Dropbox/pastehub/", getHomeDirectory() )) + "/"
                             end
    end

    def loadClient()
      name = File.expand_path( "~/.pastehub.conf" )
      if File.exist?( name )
        open( name ) { |f|
          json = JSON.parse( f.read )
          self.setupClient( { :localDbPath        => json[ 'localDbPath' ],
                              :localSyncPath      => json[ 'localSyncPath' ],
                            } )
        }
      end
    end

    attr_reader :localDbPath, :localSyncPath
  end
end
