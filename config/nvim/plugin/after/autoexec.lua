-- Example usage:
-- :AutoExec cmd.exe /C build.bat *.c,*.h

local autoexec_autogroup = vim.api.nvim_create_augroup("autoexec", { clear = true })

local autoexec = function(command, filepattern)
	local function find_special_window()
		local wins = vim.api.nvim_tabpage_list_wins(0)
		for _, win in ipairs(wins) do
			local buf = vim.api.nvim_win_get_buf(win)
			local ok, val = pcall(vim.api.nvim_buf_get_var, buf, "autoexec_output")
			if ok and val then
				return win, buf
			end
		end
		return nil, nil
	end

	local win, buf = find_special_window()
	if not win then
		local orig_win = vim.api.nvim_get_current_win()
        -- Move to the right to editor window
        if vim.bo.filetype == "neo-tree" then
            vim.cmd("wincmd l");
        end
		vim.cmd("vsplit")

		win = vim.api.nvim_get_current_win()
		buf = vim.api.nvim_create_buf(false, true)
		-- attach to window
		vim.api.nvim_win_set_buf(win, buf)
        vim.bo[buf].buftype = "nofile"
        vim.bo[buf].bufhidden = "hide"
        --vim.bo[buf].modifiable = false
        vim.bo[buf].swapfile = false
        vim.wo[win].winfixbuf = true

		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Hello World!"})

		vim.api.nvim_set_option_value("number", false, { win = win })
		vim.api.nvim_set_option_value("relativenumber", false, { win = win })
		vim.api.nvim_set_option_value("signcolumn", "no", { win = win })
		vim.api.nvim_set_option_value("foldcolumn", "0", { win = win })

		-- give buffer a custom name so we ever only open one
		vim.api.nvim_buf_set_var(buf, "autoexec_output", true)

        -- Move back to the left so for opening any file this will be the default window.
        vim.cmd("wincmd h")
		vim.api.nvim_set_current_win(orig_win)

		vim.api.nvim_set_hl(0, "AutoExecOutputGreen", { fg = "#00FF00" })
		vim.api.nvim_set_hl(0, "AutoExecOutputRed", { fg = "#FF0000" })

	end
    vim.api.nvim_clear_autocmds({ group = autoexec_autogroup })

    assert(buf ~= nil)

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = autoexec_autogroup,
        pattern = filepattern,
        callback = function()
            -- Clear the buffer
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
            local append_data = function(_, data)
                if data then
                    local line_count = vim.api.nvim_buf_line_count(buf)
                    -- Append at end of buffer
                    vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, data)
                end
            end
            vim.fn.jobstart(vim.split(command, " "), {
                stdout_buffered = true,
                on_stdout = append_data,
                on_stderr = append_data,
                on_exit = vim.schedule_wrap(function(_, code, _)
                    local line_count = vim.api.nvim_buf_line_count(buf)
                    local printOut
                    local outputColor
                    if code == 0 then
                        printOut = "** Success **"
                        outputColor = "AutoExecOutputGreen"
                    else
                        printOut = "** Failed (exit code: " .. code .. ") **"
                        outputColor = "AutoExecOutputRed"
                    end
                    vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, { printOut })
                    local ns = vim.api.nvim_create_namespace("autoexec_output")
                    vim.api.nvim_buf_set_extmark(buf, ns, line_count, 0, {
                        end_row = line_count + 1,
                        hl_group = outputColor,
                        hl_eol = true,
                    })
                end),
            })
        end,
    })
end

vim.api.nvim_create_user_command("AutoExec", function (opts)
    local cmd, pattern = opts.args:match("^(.*)%s(.+)$")
    autoexec(cmd, pattern)
end, { nargs = "+" })
