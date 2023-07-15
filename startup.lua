for i, v in pairs(fs.list("")) do
    if fs.isDir(v) then
        for j, w in pairs(fs.list(v)) do
            if w == ".," then
                shell.run(v.."/"..w)
            end
        end
    end
end
