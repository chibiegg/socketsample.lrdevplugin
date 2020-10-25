-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrSocket = import "LrSocket"
local LrLogger = import 'LrLogger'
local LrTasks = import "LrTasks"

local bind = LrView.bind
local logger = LrLogger( 'socketSamplePlugin' )
logger:enable( "logfile" )
logger:enable( "print" )

local function listen()
	import "LrTasks".startAsyncTask( function()
		LrFunctionContext.callWithContext( 'socket_remote', function( context )
			local sock = LrSocket.bind {
				plugin = _PLUGIN,
				functionContext = context,
				port = 12345,
				mode = "receive",
				onConnecting = function( socket, port )
				logger:info("onConnectiong")
				end,
				onConnected = function( socket, port )
					logger:info("onConnected")
				end,
				onMessage = function( socket, message )
					logger:infof("onMessage %s", message)
				end,
				onClosed = function( socket )
					logger:info("onClosed")
					socket:reconnect()
				end,
				onError = function( socket, err )
					logger:warnf("onError: %s", err)
					if err == "timeout" then
						socket:reconnect()
					end
				end,
			}
			while true do
				LrTasks.sleep( 1/2 ) -- seconds
			end
		end )
	end )
end


local function showCustomDialog()

	LrFunctionContext.callWithContext( "showCustomDialog", function( context )
	
	    local f = LrView.osFactory()

		local props = LrBinding.makePropertyTable( context )		

	    -- Create the contents for the dialog.
	    local c = f:row {
	
		    -- Bind the table to the view.  This enables controls to be bound
		    -- to the named field of the 'props' table.
		    bind_to_object = props,
				
		    -- add interfaces
			f:push_button {
				title = "Listen on 12345",
				action = function ( button )
					logger:info( "Listen on 12345" )
					listen()
				end
			},
		}
		
	
	    LrDialogs.presentModalDialog {
			title = "Socket Sample",
			contents = c
		}

	end) -- end main function

end


-- Now display the dialogs.
showCustomDialog()
