// WebKit 6 reference: https://webkitgtk.org/reference/webkitgtk/2.45.4/
// Gtk    4 reference: https://docs.gtk.org/gtk4

const std = @import("std");
const gtk = @cImport({
    @cInclude("gtk/gtk.h");
    @cInclude("webkit/webkit.h");
});

// https://www.joshwcomeau.com/css/custom-css-reset/
const CSS_RESET = "<style type=\"text/css\">*,::after,::before{box-sizing:border-box}*{margin:0}body{line-height:1.5;-webkit-font-smoothing:antialiased}canvas,img,picture,svg,video{display:block;max-width:100%}button,input,select,textarea{font:inherit}h1,h2,h3,h4,h5,h6,p{overflow-wrap:break-word}#__next,#root{isolation:isolate}</style>";

fn onActivate(app: *gtk.GtkApplication, data: gtk.gpointer) callconv(.C) void {
    _ = data;
    std.debug.print("on_activate\n", .{});

    const window = gtk.gtk_application_window_new(app);
    gtk.gtk_window_set_title(@ptrCast(window), "Hello, Gtk4!");
    gtk.gtk_window_set_default_size(@ptrCast(window), 800, 600);

    const webview = gtk.webkit_web_view_new();
    const html =
        \\<!DOCTYPE html>
        \\  <html>
        \\    <head>
        ++ CSS_RESET ++
        \\    </head>
        \\    <body style="width: 100vw; height: 100vh;">
        \\      <h1>Hello, World!</h1>
        \\    </body>
        \\  </html>
    ;
    gtk.webkit_web_view_load_html(@ptrCast(webview), html, null);

    // Enable dev tools
    const settings = gtk.webkit_web_view_get_settings(@ptrCast(webview));
    gtk.g_object_set(@ptrCast(settings), "enable-developer-extras", true, @as([*c]const u8, null));

    gtk.gtk_window_set_child(@ptrCast(window), webview);

    // Make sure the webview uses all available space
    gtk.gtk_widget_set_hexpand(@ptrCast(webview), @as(c_int, 1));
    gtk.gtk_widget_set_vexpand(@ptrCast(webview), @as(c_int, 1));

    gtk.gtk_window_present(@ptrCast(window));
}

pub fn main() !void {
    // https://bugs.webkit.org/show_bug.cgi?id=259644
    // WEBKIT_DISABLE_DMABUF_RENDERER=1
    std.debug.print("starting the application\n", .{});

    std.debug.print("init gtk\n", .{});
    // https://docs.gtk.org/gtk4/ctor.Application.new.html
    // https://developer.gnome.org/documentation/tutorials/application-id.html
    const app = gtk.gtk_application_new("codes.soroush.zone", gtk.G_APPLICATION_DEFAULT_FLAGS);
    defer gtk.g_object_unref(app);

    // https://docs.gtk.org/gobject/func.signal_connect_data.html
    _ = gtk.g_signal_connect_data(app, "activate", @ptrCast(&onActivate), null, null, gtk.G_CONNECT_DEFAULT);

    // When you close the window, by (for example) pressing the X button,
    // the g_application_run() call returns with a number which is saved inside
    // an integer variable named status.
    const status = gtk.g_application_run(@ptrCast(app), 0, null);
    std.debug.print("status: {d}\n", .{status});
}
