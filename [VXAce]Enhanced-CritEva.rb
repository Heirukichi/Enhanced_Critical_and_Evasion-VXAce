#==============================================================================
# HEIRUKICHI'S ENHANCED CRITICAL AND EVATION
#==============================================================================
# Version 1.0.0
# - Author: Heirukichi
# - Last update: 11-12-2019 [MM-DD-YYYY]
#==============================================================================
# DESCRIPTION
#------------------------------------------------------------------------------
# This script changes the way critical chance and evasion are calculated.
#
# Critical Chance:
#   Extra percentage critical chance is obtained subtracting the target
#   defensive parameter (either defense for physical attack or magic defense
#   for magical attacks) from the user offensive parameter (respectively attack
#   and magic attack).
#   * NOTE: Certain hit skills grant no extra critical hit at all. However, the
#           normal critical chance is still applied to the attack.
#   * NOTE 2: Extra critical is ONLY applied when critical hits are possible.
#
# Evasion:
#   Extra evasion is obtained subtracting the user offensive parameter (see
#   above) from the target defensive parameter (see above).
#   * NOTE: Certain hit skills are still unaffected by evasion.
#==============================================================================
# REQUIREMENTS
#------------------------------------------------------------------------------
# This script has no requirement and can work on its own.
#==============================================================================
# INSTRUCTIONS
#------------------------------------------------------------------------------
# Copy/paste this script in your project below Materials and above Main. When
# doing so, keep in mind how the script interacts with existing methods (see
# the paragraph "COMPATIBILITY" below).
#==============================================================================
# TERMS OF USE
#------------------------------------------------------------------------------
# This script is under the GNU General Public License v3.0. This means that:
# - You are free to use this script in both commercial and non-commercial games
#   as long as you give proper credits to me (Heirukichi) and provide a link to
#   my website;
# - You are free to modify this script as long as you do not pretend you wrote
#   this and you distribute it under the same license as the original.
#
# You can review the full license here:
# https://www.gnu.org/licenses/gpl-3.0.html
#
# In addition I'd like to keep track of games where my scripts are used so,
# even if this is not mandatory, I'd like you to inform me and send me a link
# when a game including my script is published.
# As I said, this is not mandatory but it really helps me and it is much
# appreciated.
#
# IMPORTANT NOTICE:
# If you want to distribute this code, feel free to do it, but provide a link
# to my website instead of pasting my script somewhere else.
#==============================================================================
# COMPATIBILITY
#------------------------------------------------------------------------------
# In this paragraph you can see a list of methods and how this script interacts
# with them. The following symbols are used to mark methods:
#
# + => New method
# ! => Overwritten method
# * => Aliased method
#
#------------------------------------------------------------------------------
# class Game_Battler
#   + hrk_evapp
#   + hrk_critpp
#   * item_eva
#   * item_cri
#------------------------------------------------------------------------------
# I recommend placing this script BELOW any script overwriting one of the two
# aliased methods. Placing it above them results in those scripts overwriting
# the methods in this one and prevents this script from working properly.
#------------------------------------------------------------------------------
# NOTICE
#------------------------------------------------------------------------------
# This script is meant exclusively for RPG Maker VX Ace. It is very unlikely
# that it works with other versions of RPG Maker (namely VX and XP).
#==============================================================================
$imported = {} if $imported.nil?
$imported[:HRK_Powerful_CritEva] = true
#------------------------------------------------------------------------------
# ** Game_Battler class
#------------------------------------------------------------------------------
class Game_Battler < Game_BattlerBase
  #----------------------------------------------------------------------------
  # * Extra Evasion
  #----------------------------------------------------------------------------
  def hrk_evapp(user, item)
    result = 0
    result = [(self.def - user.atk), 0].max / 100.0 if item.physical?
    result = [(self.mdf - user.mat), 0].max / 100.0 if item.magical?
    result.round(2)
  end # Extra Evasion
  #----------------------------------------------------------------------------
  # * Item Evasion (aliased method)
  #----------------------------------------------------------------------------
  alias hrk_pce_item_eva_old item_eva
  def item_eva(user, item)
    [hrk_pce_item_eva_old(user, item) + hrk_evapp(user, item), 0].max.round(2)
  end # Item Evasion
  #----------------------------------------------------------------------------
  # * Extra Critical Chance
  #----------------------------------------------------------------------------
  def hrk_critpp(user, item)
    result = 0
    result = ([(user.atk - self.def), 0].max / 100.0) if item.physical?
    result = ([(user.mat - self.mdf), 0].max / 100.0) if item.magical?
    result.round(2)
  end # Extra Critical Chance
  #----------------------------------------------------------------------------
  # * Item Critical (aliased method)
  #----------------------------------------------------------------------------
  alias hrk_pce_item_cri_old item_cri
  def item_cri(user, item)
    result = hrk_pce_item_cri_old(user, item)
    result += (item.damage.critical ? hrk_critpp(user, item) * (1 - cev) : 0)
    result.round(2)
  end # Item Critical
end # end of Game_Battler class