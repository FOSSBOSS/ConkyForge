require 'cairo'
pcall(require, 'cairo_xlib')
pcall(require, 'cairo_wayland')

function draw_horizontal_text_spaced(cr, x, y, text, font_size, r, g, b, spacing)
    cairo_select_font_face(cr, 'Hack', CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)
    cairo_set_font_size(cr, font_size)
    cairo_set_source_rgb(cr, r, g, b)
    local chars = {}
    local p = 1
    while p <= string.len(text) do
        local c = string.byte(text, p)
        local shift = 1
        if c > 0 and c <= 127 then shift = 1
        elseif c >= 192 and c <= 223 then shift = 2
        elseif c >= 224 and c <= 239 then shift = 3
        elseif c >= 240 and c <= 247 then shift = 4 end
        table.insert(chars, string.sub(text, p, p + shift - 1))
        p = p + shift
    end
    local total_width = 0
    local extents = cairo_text_extents_t:create()
    for _, char in ipairs(chars) do
        cairo_text_extents(cr, char, extents)
        total_width = total_width + extents.x_advance
    end
    total_width = total_width + (#chars - 1) * spacing
    cairo_text_extents(cr, 'A', extents)
    local current_x = x - (total_width / 2)
    local current_y = y - (extents.height / 2 + extents.y_bearing)
    for _, char in ipairs(chars) do
        cairo_move_to(cr, current_x, current_y)
        cairo_show_text(cr, char)
        cairo_text_extents(cr, char, extents)
        current_x = current_x + extents.x_advance + spacing
    end
    cairo_stroke(cr)
end

function draw_stacked_vertical_text(cr, box_x, box_y, box_w, box_h, text, font_size, r, g, b, spacing)
    cairo_select_font_face(cr, 'Hack', CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)
    cairo_set_font_size(cr, font_size)
    cairo_set_source_rgb(cr, r, g, b)
    local chars = {}
    local p = 1
    while p <= string.len(text) do
        local c = string.byte(text, p)
        local shift = 1
        if c > 0 and c <= 127 then shift = 1
        elseif c >= 192 and c <= 223 then shift = 2
        elseif c >= 224 and c <= 239 then shift = 3
        elseif c >= 240 and c <= 247 then shift = 4 end
        table.insert(chars, string.sub(text, p, p + shift - 1))
        p = p + shift
    end
    local len = #chars
    if len == 0 then return end
    local step = 0
    if len > 1 then step = (box_h - font_size) / (len - 1) + spacing end
    for i, char in ipairs(chars) do
        local extents = cairo_text_extents_t:create()
        cairo_text_extents(cr, char, extents)
        local char_x = box_x + (box_w / 2) - (extents.width / 2 + extents.x_bearing)
        local char_y = box_y + ((i-1) * step) + font_size - (font_size * 0.1)
        cairo_move_to(cr, char_x, char_y)
        cairo_show_text(cr, char)
    end
    cairo_stroke(cr)
end

function draw_image_base(cr, x, y, w, h, path)
    local image = cairo_image_surface_create_from_png(path)
    if cairo_surface_status(image) == CAIRO_STATUS_SUCCESS then
        local img_w = cairo_image_surface_get_width(image)
        local img_h = cairo_image_surface_get_height(image)
        cairo_save(cr)
        cairo_translate(cr, x, y)
        cairo_scale(cr, w / img_w, h / img_h)
        cairo_set_source_surface(cr, image, 0, 0)
        cairo_paint(cr)
        cairo_restore(cr)
        cairo_surface_destroy(image)
    else
        draw_horizontal_text_spaced(cr, x + w/2, y + h/2, 'ERROR PNG', 12, 1, 0, 0, 0)
    end
end

function draw_analog_clock(cr, x, y, radius, bg_rgb, fg_rgb, ac_rgb)
    local time_h = tonumber(os.date('%I')) or 0
    local time_m = tonumber(os.date('%M')) or 0
    local time_s = tonumber(os.date('%S')) or 0
    cairo_arc(cr, x, y, radius, 0, 2*math.pi)
    cairo_set_source_rgba(cr, bg_rgb[1], bg_rgb[2], bg_rgb[3], 0.1)
    cairo_fill(cr)
    cairo_set_source_rgba(cr, bg_rgb[1], bg_rgb[2], bg_rgb[3], 0.5)
    cairo_set_line_width(cr, 2)
    for i=1,12 do
        cairo_move_to(cr, x + math.sin(math.pi/6 * i) * (radius*0.85), y - math.cos(math.pi/6 * i) * (radius*0.85))
        cairo_line_to(cr, x + math.sin(math.pi/6 * i) * radius, y - math.cos(math.pi/6 * i) * radius)
        cairo_stroke(cr)
    end
    local h_angle = (time_h * 30 + time_m / 2) * math.pi / 180
    cairo_set_source_rgba(cr, fg_rgb[1], fg_rgb[2], fg_rgb[3], 1.0)
    cairo_set_line_width(cr, 4)
    cairo_move_to(cr, x, y)
    cairo_line_to(cr, x + math.sin(h_angle) * (radius*0.5), y - math.cos(h_angle) * (radius*0.5))
    cairo_stroke(cr)
    local m_angle = (time_m * 6 + time_s / 10) * math.pi / 180
    cairo_set_line_width(cr, 2)
    cairo_move_to(cr, x, y)
    cairo_line_to(cr, x + math.sin(m_angle) * (radius*0.8), y - math.cos(m_angle) * (radius*0.8))
    cairo_stroke(cr)
    local s_angle = time_s * 6 * math.pi / 180
    cairo_set_source_rgba(cr, ac_rgb[1], ac_rgb[2], ac_rgb[3], 1.0)
    cairo_set_line_width(cr, 1)
    cairo_move_to(cr, x, y)
    cairo_line_to(cr, x + math.sin(s_angle) * (radius*0.9), y - math.cos(s_angle) * (radius*0.9))
    cairo_stroke(cr)
    cairo_arc(cr, x, y, 3, 0, 2*math.pi)
    cairo_fill(cr)
end

function draw_ring(cr, t, pt, raw_val, label)
    local angle_0 = t.start_angle * (math.pi/180) - (math.pi/2)
    local angle_f = t.end_angle * (math.pi/180) - (math.pi/2)
    local t_arc = pt * (angle_f - angle_0)
    cairo_arc(cr, t.x, t.y, t.radius, angle_0, angle_f)
    cairo_set_source_rgba(cr, t.bgc[1], t.bgc[2], t.bgc[3], t.bga)
    cairo_set_line_width(cr, t.thickness)
    cairo_stroke(cr)
    if pt > 0 then
        local r, g, b = t.fgc[1], t.fgc[2], t.fgc[3]
        if pt >= 0.80 then r, g, b = 1.0, 0.33, 0.33 end
        cairo_arc(cr, t.x, t.y, t.radius, angle_0, angle_0 + t_arc)
        cairo_set_source_rgba(cr, r, g, b, t.fga)
        cairo_stroke(cr)
        local val_text = string.format('%d%s', raw_val, t.suffix or '%%')
        draw_horizontal_text_spaced(cr, t.x, t.y - t.scale_offset, val_text, t.font_val, r, g, b, 0)
    else
        local val_text = string.format('0%s', t.suffix or '%%')
        draw_horizontal_text_spaced(cr, t.x, t.y - t.scale_offset, val_text, t.font_val, t.fgc[1], t.fgc[2], t.fgc[3], 0)
    end
    draw_horizontal_text_spaced(cr, t.x, t.y + t.scale_offset * 2.5, label, t.font_lbl, 1, 1, 1, 0)
end

function draw_concentric_gpu(cr, x, y, radius, thickness, temp_val, mem_val, label, txt_rgb, tmp_rgb, mem_rgb)
    local start_a = 135 * (math.pi/180)
    local end_a = 405 * (math.pi/180)
    local span = end_a - start_a

    cairo_arc(cr, x, y, radius, start_a, end_a)
    cairo_set_source_rgba(cr, 1, 1, 1, 0.1)
    cairo_set_line_width(cr, thickness)
    cairo_stroke(cr)
    local t_pt = math.min(temp_val / 100, 1)
    if t_pt > 0 then
        cairo_arc(cr, x, y, radius, start_a, start_a + (span * t_pt))
        cairo_set_source_rgba(cr, tmp_rgb[1], tmp_rgb[2], tmp_rgb[3], 1)
        cairo_stroke(cr)
    end

    local in_rad = radius - thickness - 4
    cairo_arc(cr, x, y, in_rad, start_a, end_a)
    cairo_set_source_rgba(cr, 1, 1, 1, 0.1)
    cairo_set_line_width(cr, thickness)
    cairo_stroke(cr)
    local m_pt = math.min(mem_val / 100, 1)
    if m_pt > 0 then
        cairo_arc(cr, x, y, in_rad, start_a, start_a + (span * m_pt))
        cairo_set_source_rgba(cr, mem_rgb[1], mem_rgb[2], mem_rgb[3], 1)
        cairo_stroke(cr)
    end

    draw_horizontal_text_spaced(cr, x, y - 8, label, 16, txt_rgb[1], txt_rgb[2], txt_rgb[3], 0)
    draw_horizontal_text_spaced(cr, x, y + 8, temp_val .. '°C', 10, tmp_rgb[1], tmp_rgb[2], tmp_rgb[3], 0)
    draw_horizontal_text_spaced(cr, x, y + 20, mem_val .. '%', 10, mem_rgb[1], mem_rgb[2], mem_rgb[3], 0)
end

function draw_eq_vertical(cr, x, y, w, h, count, base_rgb)
    local space = 2
    local bar_w = (w / count) - space
    for i=1, count do
        local val = tonumber(conky_parse('${cpu cpu'..i..'}')) or 0
        local pt = val / 100
        local bar_h = pt * h
        cairo_rectangle(cr, x + (i-1)*(bar_w+space), y, bar_w, h)
        cairo_set_source_rgba(cr, 1, 1, 1, 0.05)
        cairo_fill(cr)
        local r, g, b = base_rgb[1], base_rgb[2], base_rgb[3]
        if pt >= 0.80 then r, g, b = 1.0, 0.33, 0.33 end
        cairo_rectangle(cr, x + (i-1)*(bar_w+space), y + h - bar_h, bar_w, bar_h)
        cairo_set_source_rgba(cr, r, g, b, 0.9)
        cairo_fill(cr)
    end
end

function conky_main_visuals()
    if conky_window == nil then return end
    local cs
    if cairo_xlib_surface_create ~= nil then
        cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    elseif cairo_wayland_surface_create ~= nil then
        cs = cairo_wayland_surface_create(conky_window.display, conky_window.surface, conky_window.width, conky_window.height)
    else
        print('Error ConkyForge: No se encontro la superficie de dibujo en cairo (Ni X11 ni Wayland).')
        return
    end
    local cr = cairo_create(cs)
    local updates = tonumber(conky_parse('${updates}')) or 0
    if updates > 3 then
        local current_frame = math.floor(updates / 1) % 36 + 1
        draw_image_base(cr, 1110, 40, 150, 150, "/home/ka/.conky/conky-draw/framess/frame" .. current_frame .. ".png")
        draw_image_base(cr, 1080, 260, 223, 217, "/home/ka/ka.png")
        draw_horizontal_text_spaced(cr, 2746, 188, "CONKY", 150, 0.631, 0.463, 0.635, 15)
        draw_stacked_vertical_text(cr, 3040, 110, 140, 764, "FORGE", 150, 0.631, 0.463, 0.635, 0)
        draw_eq_vertical(cr, 3720, 180, 1076, 1580, 16, {0.741, 0.576, 0.976})
        draw_analog_clock(cr, 2729, 571, 244, {0.494, 0.796, 0.945}, {0.631, 0.463, 0.635}, {1.000, 0.333, 0.333})
        draw_horizontal_text_spaced(cr, 3110, 992, "2.0", 150, 0.631, 0.463, 0.635, -30)
        local raw_val = tonumber(conky_parse('${memperc}')) or 0
        draw_ring(cr, {x=3376, y=1490, radius=255, thickness=37, font_val=22, font_lbl=15, scale_offset=10, start_angle=0, end_angle=360, bgc={1,1,1}, bga=0.1, fgc={0.314, 0.980, 0.482}, fga=1, suffix="%%"}, raw_val/100, raw_val, "RAM")
        local raw_val = tonumber(conky_parse('${cpu cpu0}')) or 0
        draw_ring(cr, {x=2654, y=1488, radius=253, thickness=37, font_val=22, font_lbl=15, scale_offset=10, start_angle=0, end_angle=360, bgc={1,1,1}, bga=0.1, fgc={0.741, 0.576, 0.976}, fga=1, suffix="%%"}, raw_val/100, raw_val, "CPU")
        local gpu_temp = tonumber(conky_parse('${execi 2 nvidia-smi -i 0 --query-gpu=temperature.gpu --format=csv,noheader}')) or 0
        local gpu_mem = tonumber(conky_parse('${execi 2 nvidia-smi -i 0 --query-gpu=utilization.memory --format=csv,noheader | tr -d " %%"}')) or 0
        draw_concentric_gpu(cr, 1959, 1484, 249, 30, gpu_temp, gpu_mem, "NVIDIA 0", {0.494, 0.796, 0.945}, {1.000, 0.333, 0.333}, {0.314, 0.980, 0.482})
        local gpu_temp = tonumber(conky_parse('${execi 2 nvidia-smi -i 1 --query-gpu=temperature.gpu --format=csv,noheader}')) or 0
        local gpu_mem = tonumber(conky_parse('${execi 2 nvidia-smi -i 1 --query-gpu=utilization.memory --format=csv,noheader | tr -d " %%"}')) or 0
        draw_concentric_gpu(cr, 1296, 1482, 246, 30, gpu_temp, gpu_mem, "NVIDIA 1", {0.494, 0.796, 0.945}, {1.000, 0.333, 0.333}, {0.314, 0.980, 0.482})
    end
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end
