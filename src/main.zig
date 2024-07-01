const std = @import("std");
const gtk = @cImport({
    @cInclude("gtk/gtk.h");
});

fn on_activate(app: *gtk.GtkApplication, data: gtk.gpointer) callconv(.C) void {
    _ = data;
    std.debug.print("on_activate\n", .{});

    const window = gtk.gtk_application_window_new(app);
    gtk.gtk_window_set_title(@ptrCast(window), "Hello, Gtk4!");
    gtk.gtk_window_set_default_size(@ptrCast(window), 800, 600);
    gtk.gtk_window_present(@ptrCast(window));
}

pub fn main() !void {
    std.debug.print("starting the application\n", .{});

    std.debug.print("init gtk\n", .{});
    // https://docs.gtk.org/gtk4/ctor.Application.new.html
    // https://developer.gnome.org/documentation/tutorials/application-id.html
    const app = gtk.gtk_application_new("codes.soroush.zone", gtk.G_APPLICATION_DEFAULT_FLAGS);
    defer gtk.g_object_unref(app);

    // https://docs.gtk.org/gobject/func.signal_connect_data.html
    _ = gtk.g_signal_connect_data(app, "activate", @ptrCast(&on_activate), null, null, gtk.G_CONNECT_DEFAULT);

    // When you close the window, by (for example) pressing the X button,
    // the g_application_run() call returns with a number which is saved inside
    // an integer variable named status.
    const status = gtk.g_application_run(@ptrCast(app), 0, null);
    std.debug.print("status: {d}\n", .{status});
}
