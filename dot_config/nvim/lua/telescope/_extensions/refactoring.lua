local function refactors()
  return require("refactoring").select_refactor()
end

return require("telescope").register_extension({
  exports = {
    refactors = refactors,
  },
})
