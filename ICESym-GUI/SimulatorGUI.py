#!/usr/bin/env python
# -*- coding: utf-8 -*-
# generated by wxGlade 0.6.3 on Mon May 18 09:43:57 2009

import wx
from Home import Home

#----------------------------------------------------------------------
# We first have to set an application-wide help provider.  Normally you
# would do this in your app's OnInit or in other startup code...

provider = wx.SimpleHelpProvider()
wx.HelpProvider.Set(provider)

class SimulatorGUI(wx.App):
    def OnInit(self):
        wx.InitAllImageHandlers()
        home = Home(self, None, -1, "")
        self.SetTopWindow(home)
        home.Show()
        return 1

# end of class SimulatorGUI

if __name__ == "__main__":
    SimulatorGUI = SimulatorGUI(0)
    SimulatorGUI.MainLoop()
