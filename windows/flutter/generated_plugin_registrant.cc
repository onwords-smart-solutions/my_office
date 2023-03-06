//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <connectivity_plus_windows/connectivity_plus_windows_plugin.h>
#include <upi_payment_qrcode_generator/upi_payment_qrcode_generator_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  ConnectivityPlusWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ConnectivityPlusWindowsPlugin"));
  UpiPaymentQrcodeGeneratorPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UpiPaymentQrcodeGeneratorPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
