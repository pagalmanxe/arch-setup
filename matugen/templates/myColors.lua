-- Matugen-generated Hyprland colors (source this from hyprland.lua)
-- Usage: add  require("myColors")  near the top of hyprland.lua, then
--        reference e.g.  colors.primary  in your windowrulev2/border config.
return {
    background    = "{{ colors.background.default.hex }}",
    surface       = "{{ colors.surface.default.hex }}",
    on_surface    = "{{ colors.on_surface.default.hex }}",
    on_surface_variant = "{{ colors.on_surface_variant.default.hex }}",
    primary       = "{{ colors.primary.default.hex }}",
    primary_container = "{{ colors.primary_container.default.hex }}",
    secondary     = "{{ colors.secondary.default.hex }}",
    secondary_container = "{{ colors.secondary_container.default.hex }}",
    tertiary      = "{{ colors.tertiary.default.hex }}",
    tertiary_container = "{{ colors.tertiary_container.default.hex }}",
    error         = "{{ colors.error.default.hex }}",
    outline       = "{{ colors.outline.default.hex }}",
    shadow        = "{{ colors.shadow.default.hex }}",
}
