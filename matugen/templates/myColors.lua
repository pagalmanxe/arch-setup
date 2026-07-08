-- Matugen-generated Hyprland colors (derived from wallpaper)
-- To use: in hyprland.lua, uncomment `require("myColors")` and reference the table
-- returned here, e.g. `local c = require("myColors"); hl.exec_cmd("hyprctl keyword general:col.active_border " .. c.foam)`
return {
    base        = "{{ colors.surface_container_lowest.default.hex }}",
    surface     = "{{ colors.surface.default.hex }}",
    overlay     = "{{ colors.surface_container_high.default.hex }}",
    muted       = "{{ colors.on_surface_variant.default.hex }}",
    text        = "{{ colors.on_surface.default.hex }}",
    love        = "{{ colors.error.default.hex }}",
    gold        = "{{ colors.tertiary.default.hex }}",
    rose        = "{{ colors.secondary.default.hex }}",
    pine        = "{{ colors.secondary_container.default.hex }}",
    foam        = "{{ colors.primary.default.hex }}",
    iris        = "{{ colors.primary_container.default.hex }}",
}
