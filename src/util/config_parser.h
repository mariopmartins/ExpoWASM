#include "common.h"
#include "../../lib/nlohmann/json.hpp"

using Json = nlohmann::json;

/*
 * Keep track of config info
 * Three main fields: param(query param), header, cookie
 *
 * If <field>_include is true, <field>s contains the names to be included in
 * sql injection detection
 * If <filed>_include is false, <field>s contains the names to be excluded
 */
struct Config {
  std::string content_type{URLENCODED};

  bool body_include{false};
  Keys body{};

  bool path_include{false};
  Keys path{};

  bool header_include{true};
  Keys headers{"referer", "user-agent"};

  bool cookie_include{false};
  Keys cookies{};

  std::string to_string();
};

/*
 * Parse a string into config
 *
 * Input:
 *  configuration - the string to be parsed into config
 *  config - pointer to store the parsed config
 *  trace - pointer to store the trace in the process
 *
 * Output:
 *  true on success, false on failure
 */
bool parseConfig(std::string configuration, Config* config, std::string* trace);
