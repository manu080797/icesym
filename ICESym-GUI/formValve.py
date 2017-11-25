# -*- coding: utf-8 -*-
# generated by wxGlade 0.6.3 on Mon May 18 09:43:57 2009

import wx
from validations import numberValidator
from extraFunctions import *
from help_texts import help_valve

# begin wxGlade: dependencies
import wx.grid
from Plots import Plots
# end wxGlade

# begin wxGlade: extracode

# end wxGlade

class formValve(wx.Dialog):
    edit = -1
    data = {}
    position = (0,0)

    def __init__(self, *args, **kwds):
        # begin wxGlade: formValve.__init__
        kwds["style"] = wx.DEFAULT_DIALOG_STYLE|wx.RESIZE_BORDER
        wx.Dialog.__init__(self, *args, **kwds)
        self.panel_buttons = wx.Panel(self, -1)
        self.panel_configure = wx.Panel(self, -1, style=wx.TAB_TRAVERSAL)
        self.configure_notebook = wx.Notebook(self.panel_configure, -1, style=0)
        #self.notebook_state = wx.ScrolledWindow(self.configure_notebook, -1, style=wx.TAB_TRAVERSAL)
        self.notebook_post = wx.ScrolledWindow(self.configure_notebook, -1, style=wx.TAB_TRAVERSAL)
        self.notebook_general = wx.ScrolledWindow(self.configure_notebook, -1, style=wx.TAB_TRAVERSAL)
        self.label_0 = wx.StaticText(self.notebook_general, -1, "Number of Valves:")
        self.data['Nval'] = wx.TextCtrl(self.notebook_general, -1, "")
        self.label_1 = wx.StaticText(self.notebook_general, -1, "Valve Lift:")
        self.data['type_dat'] = wx.RadioBox(self.notebook_general, -1, "", choices=["Exponential", "Squared Sin", "User-defined"], majorDimension=0, style=wx.RA_SPECIFY_ROWS)
        self.label_2 = wx.StaticText(self.notebook_general, -1, "Opening Angle [deg]:")
        self.data['angle_V0'] = wx.TextCtrl(self.notebook_general, -1, "")
        self.label_3 = wx.StaticText(self.notebook_general, -1, "Closing Angle [deg]:")
        self.data['angle_VC'] = wx.TextCtrl(self.notebook_general, -1, "")
        self.label_4 = wx.StaticText(self.notebook_general, -1, "Diameter [mm]:")
        self.data['Dv'] = wx.TextCtrl(self.notebook_general, -1, "")
        self.label_5 = wx.StaticText(self.notebook_general, -1, "Valve Model:")
        self.data['valve_model'] = wx.RadioBox(self.notebook_general, -1, "", choices=["Toyota", "Alessandri"], majorDimension=0, style=wx.RA_SPECIFY_ROWS)
        self.label_6 = wx.StaticText(self.notebook_general, -1, "Type of Valve:")
        self.data['type'] = wx.RadioBox(self.notebook_general, -1, "", choices=["Intake Valve", "Exhaust Valve"], majorDimension=0, style=wx.RA_SPECIFY_ROWS)
        self.label_7 = wx.StaticText(self.notebook_general, -1, "Max. Valve Lift [mm]:")
        self.data['Lvmax'] = wx.TextCtrl(self.notebook_general, -1, "")
        self.label_8 = wx.StaticText(self.notebook_general, -1, "Valve Lift Definition:")
        self.button_1 = wx.Button(self.notebook_general, -1, "load")
        self.button_1b = wx.Button(self.notebook_general, -1, "plot")
        self.data['Lv'] = wx.grid.Grid(self.notebook_general, -1, size=(1, 1))
        self.label_9_copy = wx.StaticText(self.notebook_general, -1, "Discharge Coefficient:")
        self.button_2 = wx.Button(self.notebook_general, -1, "load")
        self.button_2b = wx.Button(self.notebook_general, -1, "plot")
        self.data['Cd'] = wx.grid.Grid(self.notebook_general, -1, size=(1, 1))
        self.panel_31 = wx.Panel(self.notebook_general, -1)
        self.panel_32 = wx.Panel(self.notebook_general, -1)
        #self.data['histo'] = wx.grid.Grid(self.notebook_state, -1, size=(1, 1))
        self.data['histo'] = wx.CheckBox(self.notebook_post, -1, "Save Own State")
        self.data['label'] = wx.TextCtrl(self.notebook_general, -1, "")
        self.label_12 = wx.StaticText(self.notebook_general, -1, "Label:")
        #self.button_3 = wx.Button(self.notebook_state, -1, "...")
        self.accept = wx.Button(self.panel_buttons, wx.ID_OK, "")
        self.cancel = wx.Button(self.panel_buttons, wx.ID_CANCEL, "")
        self.help = wx.ContextHelpButton(self.panel_buttons)

        self.__set_properties()
        self.setContextualHelp()
        self.__do_layout()

        self.Bind(wx.EVT_RADIOBOX, self.onTypeDat, self.data['type_dat'])
        self.Bind(wx.EVT_BUTTON, self.onLoadLvmax, self.button_1)
        self.Bind(wx.EVT_BUTTON, self.onPlotLvmax, self.button_1b)
        self.Bind(wx.EVT_BUTTON, self.onLoadDC, self.button_2)
        self.Bind(wx.EVT_BUTTON, self.onPlotDC, self.button_2b)
        #self.Bind(wx.EVT_BUTTON, self.onLoadState, self.button_3)
        self.Bind(wx.EVT_BUTTON, self.ConfigureAccept, self.accept)
        # end wxGlade

    def __set_properties(self):
        # begin wxGlade: formValve.__set_properties
        self.SetTitle("Configure Valve")
        self.SetSize(wx.DLG_UNIT(self, wx.Size(300, 280)))
        self.label_0.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['Nval'].SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.label_1.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['type_dat'].SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['type_dat'].SetSelection(0)
        self.label_2.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['angle_V0'].SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['angle_V0'].SetValidator(numberValidator())
        self.label_3.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['angle_VC'].SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['angle_VC'].SetValidator(numberValidator())
        self.label_4.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['Dv'].SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['Dv'].SetValidator(numberValidator())
        self.label_5.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['valve_model'].SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['valve_model'].SetSelection(0)
        self.label_6.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['type'].SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['type'].SetSelection(0)
        self.label_7.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['Lvmax'].SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['Lvmax'].SetValidator(numberValidator())
        self.label_8.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.button_1.SetMinSize(wx.DLG_UNIT(self.button_1, wx.Size(20, 13)))
        self.button_1.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.button_1b.SetMinSize(wx.DLG_UNIT(self.button_1b, wx.Size(20, 13)))
        self.button_1b.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['Lv'].CreateGrid(5, 2)
        self.data['Lv'].SetRowLabelSize(20)
        self.data['Lv'].SetColLabelSize(20)
        self.data['Lv'].EnableDragColSize(0)
        self.data['Lv'].EnableDragRowSize(0)
        self.data['Lv'].EnableDragGridSize(0)
        self.data['Lv'].SetColLabelValue(0, "Angle [deg]")
        self.data['Lv'].SetColLabelValue(1, "Lift [mm]")
        self.data['Lv'].SetMinSize(wx.DLG_UNIT(self.data['Lv'], wx.Size(120, 100)))
        self.data['Lv'].SetDefaultCellFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['Lv'].SetDefaultRowSize(18)
        self.data['Lv'].SetLabelFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.label_9_copy.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.button_2.SetMinSize(wx.DLG_UNIT(self.button_2, wx.Size(20, 13)))
        self.button_2.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.button_2b.SetMinSize(wx.DLG_UNIT(self.button_2b, wx.Size(20, 13)))
        self.button_2b.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['Cd'].CreateGrid(10, 2)
        self.data['Cd'].SetRowLabelSize(20)
        self.data['Cd'].SetColLabelSize(20)
        self.data['Cd'].EnableDragColSize(0)
        self.data['Cd'].EnableDragRowSize(0)
        self.data['Cd'].EnableDragGridSize(0)
        self.data['Cd'].SetColLabelValue(0, "Lift [mm]")
        self.data['Cd'].SetColLabelValue(1, "Cd")
        self.data['Cd'].SetMinSize(wx.DLG_UNIT(self.data['Cd'], wx.Size(120, 99)))
        self.data['Cd'].SetDefaultCellFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['Cd'].SetDefaultRowSize(18)
        self.data['Cd'].SetLabelFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.notebook_general.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.notebook_general.SetScrollRate(10, 10)
        #self.data['histo'].CreateGrid(1, 3)
        #self.data['histo'].SetRowLabelSize(25)
        #self.data['histo'].SetColLabelSize(15)
        #self.data['histo'].EnableDragColSize(0)
        #self.data['histo'].EnableDragRowSize(0)
        #self.data['histo'].EnableDragGridSize(0)
        #self.data['histo'].SetColLabelValue(0, "Density")
        #self.data['histo'].SetColLabelValue(1, "Velocity")
        #self.data['histo'].SetColLabelValue(2, "Pressure")
        #self.data['histo'].SetMinSize(wx.DLG_SZE(self.data['histo'], (161, 100)))
        #self.data['histo'].SetDefaultCellFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        #self.data['histo'].SetDefaultRowSize(18)
        #self.data['histo'].SetLabelFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['histo'].SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.data['label'].SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.label_12.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        #self.button_3.SetMinSize(wx.DLG_SZE(self.button_3, (16, 11)))
        #self.notebook_state.SetScrollRate(10, 10)
        self.configure_notebook.SetMinSize(wx.DLG_UNIT(self.configure_notebook, wx.Size(310, 94)))
        self.configure_notebook.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, ""))
        self.panel_configure.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.accept.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.cancel.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        # end wxGlade

    def __do_layout(self):
        # begin wxGlade: formValve.__do_layout
        configure_background = wx.BoxSizer(wx.VERTICAL)
        sizer_buttons = wx.GridSizer(1, 3, 0, 0)
        configure_sizer_copy = wx.BoxSizer(wx.HORIZONTAL)
        #grid_sizer_state = wx.FlexGridSizer(2, 2, 0, 0)
        grid_sizer_back = wx.FlexGridSizer(1, 2, 0, 8)
        grid_sizer_left = wx.FlexGridSizer(9, 2, 5, 0)
        grid_sizer_right = wx.FlexGridSizer(3, 2, 4, 0)
        grid_sizer_Cd = wx.FlexGridSizer(2, 1, 0, 0)
        grid_sizer_Cdsub = wx.FlexGridSizer(2, 1, 0, 0)
        grid_sizer_Lv = wx.FlexGridSizer(2, 1, 0, 0)
        grid_sizer_Lvsub = wx.FlexGridSizer(2, 1, 0, 0)

        grid_sizer_left.Add(self.label_12, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.data['label'], 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.label_6, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.data['type'], 0, 0, 0)
        grid_sizer_left.Add(self.label_0, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.data['Nval'], 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.label_1, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.data['type_dat'], 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.label_2, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.data['angle_V0'], 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.label_3, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.data['angle_VC'], 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.label_4, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.data['Dv'], 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.label_7, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.data['Lvmax'], 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.label_5, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_left.Add(self.data['valve_model'], 0, 0, 0)
        grid_sizer_back.Add(grid_sizer_left, 1, wx.EXPAND, 0)

        grid_sizer_Lv.Add(self.label_8, 0, 0, 0)
        grid_sizer_Lvsub.Add(self.button_1, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_sizer_Lvsub.Add(self.button_1b, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_sizer_Lv.Add(grid_sizer_Lvsub, 1, wx.EXPAND, 0)
        grid_sizer_right.Add(grid_sizer_Lv, 1, wx.EXPAND, 0)
        grid_sizer_right.Add(self.data['Lv'], 1, wx.EXPAND, 0)
        self.data['Lv'].Enable(False)
        grid_sizer_Cd.Add(self.label_9_copy, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_Cdsub.Add(self.button_2, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_sizer_Cdsub.Add(self.button_2b, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_sizer_Cd.Add(grid_sizer_Cdsub, 1, wx.EXPAND, 0)
        grid_sizer_right.Add(grid_sizer_Cd, 1, wx.EXPAND, 0)
        grid_sizer_right.Add(self.data['Cd'], 1, wx.EXPAND, 0)
        grid_sizer_right.Add(self.panel_31, 1, wx.EXPAND, 0)
        grid_sizer_right.Add(self.panel_32, 1, wx.EXPAND, 0)
        grid_sizer_back.Add(grid_sizer_right, 1, wx.EXPAND, 0)

        self.notebook_general.SetSizer(grid_sizer_back)

        #grid_sizer_state.Add(self.data['histo'], 1, wx.EXPAND, 0)
        #grid_sizer_state.Add(self.button_3, 0, 0, 0)
		#msgState =  wx.StaticText(self.notebook_state, -1, "This Data will be take from the connected tube")
        #self.notebook_state.SetSizer(grid_sizer_state)

        grid_sizer_111 = wx.FlexGridSizer(1, 2, 0, 0)
        grid_sizer_111.Add(self.data['histo'], 0, 0, 0)
        self.notebook_post.SetSizer(grid_sizer_111)

        self.configure_notebook.AddPage(self.notebook_general, "General")
        #self.configure_notebook.AddPage(self.notebook_state, "State")
        self.configure_notebook.AddPage(self.notebook_post, "Post Process")
        configure_sizer_copy.Add(self.configure_notebook, 1, wx.EXPAND, 0)
        self.panel_configure.SetSizer(configure_sizer_copy)
        configure_background.Add(self.panel_configure, 1, wx.ALL|wx.EXPAND|wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 8)
        sizer_buttons.Add(self.accept, 0, wx.ALIGN_RIGHT|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_buttons.Add(self.help, 0, wx.ALIGN_CENTER_VERTICAL|wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_buttons.Add(self.cancel, 0, wx.ALIGN_CENTER_VERTICAL|wx.ALIGN_LEFT, 0)
        self.panel_buttons.SetSizer(sizer_buttons)
        configure_background.Add(self.panel_buttons, 0, wx.EXPAND, 0)
        self.SetSizer(configure_background)
        self.Layout()

        # end wxGlade

    def OnValveAccept(self, event): # wxGlade: formValve.<event_handler>
        can_out=1
        for key in self.data:
            if (self.data[key].GetValidator()):
                if(not(self.data[key].GetValidator().Validate(self,'number'))):
                    can_out=0
        if(can_out==1):
		    self.EndModal(wx.ID_OK)
        else:
            wx.MessageBox("Some fields have some error (empty or no-digit value)!", "Error")

    def OnValveCancel(self, event): # wxGlade: formValve.<event_handler>
        self.Close()

    def ConfigureAccept(self, event): # wxGlade: formValve.<event_handler>
        can_out=1
        no_check = []
        if self.data['type_dat'].GetSelection()==2: 
            no_check = ['Lvmax']
        for key in self.data:
            if self.data[key].GetValidator() and not(key in no_check):
                if(not(self.data[key].GetValidator().Validate(self,'number'))):
                    can_out=0
        
        if(can_out==1):
            self.EndModal(wx.ID_OK)
        else:
            wx.MessageBox("Some fields have some error (empty or no-digit value)!", "Error")

    def onLoadLvmax(self, event): # wxGlade: formValve.<event_handler>
        if self.data['Lv'].IsEnabled():
            dlg = wx.FileDialog(self, message="Open a Data File", defaultDir="./loads",defaultFile="", wildcard="*.txt", style=wx.FD_OPEN)
            if dlg.ShowModal() == wx.ID_OK:
                namefile = dlg.GetPath()
                data = loadData(namefile,"n",2)
                if(data==-1):
                    wx.MessageBox("Incorrect data", "Error")
                else:	
                    setGrid(data,self.data['Lv'])
            dlg.Destroy()
            self.setLabels()
        else:
            wx.MessageBox("You must active 'user-defined'", "Error") 

    def onLoadDC(self, event): # wxGlade: formValve.<event_handler>
        if self.data['Cd'].IsEnabled():
            dlg = wx.FileDialog(self, message="Open a Data File", defaultDir="./loads",defaultFile="", wildcard="*.txt", style=wx.FD_OPEN)
            if dlg.ShowModal() == wx.ID_OK:
                namefile = dlg.GetPath()
                data = loadData(namefile,"n",2)
                if(data==-1):
                    wx.MessageBox("Incorrect data", "Error")
                else:				
                    setGrid(data,self.data['Cd'])
            dlg.Destroy()
            self.setLabels()
        else:
            wx.MessageBox("You must active this field", "Error") 


    def onTypeDat(self, event): # wxGlade: formValve.<event_handler>       
        td = self.data['type_dat'].GetSelection()
        if td == 2:
            self.data['Lvmax'].Enable(0)
            self.data['Lv'].Enable(1)
        else:
            self.data['Lvmax'].Enable(1)
            self.data['Lv'].Enable(0)

    def onLoadState(self, event): # wxGlade: formValve.<event_handler>
        try:
            ndof = 3
            nodes = int(self.data['Nval'].GetValue())
            if self.data['histo'].IsEnabled():
                dlg = wx.FileDialog(self, message="Open a Data File", defaultDir="./loads",defaultFile="", wildcard="*.txt", style=wx.FD_OPEN)
                if dlg.ShowModal() == wx.ID_OK:
                    namefile = dlg.GetPath()
                    data = loadData(namefile,nodes,ndof)
                    if(data==-1):
                        wx.MessageBox("Incorrect data", "Error")
                    else:	
                        setGrid(data,self.data['histo'])
                dlg.Destroy()
                self.setLabels()
            else:
                wx.MessageBox("You must active 'user-defined'", "Error") 
       	except ValueError:
            wx.MessageBox("You must complete number of valves first", "Error")

    def onPlotLvmax(self, event): # wxGlade: formValve.<event_handler>
        if not(self.data['Lv'].IsEnabled()):
            wx.MessageBox("Plot not available", "Error") 
        else:
            points = data2tuple(self.data['Lv'])
            if points:
                formPlot = Plots(None,-1, "")
                formPlot.plotData(points,"Lv")
                formPlot.ShowModal()
                formPlot.Destroy()

    def onPlotDC(self, event): # wxGlade: formValve.<event_handler>
        if not(self.data['Cd'].IsEnabled()):
            wx.MessageBox("Plot not available", "Error") 
        else:
            points = data2tuple(self.data['Cd'])
            if points:
                formPlot = Plots(None,-1, "")
                formPlot.plotData(points,"Discharge Coefficient")
                formPlot.ShowModal()
                formPlot.Destroy()

    def setLabels(self):
		#self.data['histo'].SetColLabelValue(0, "Density")
		#self.data['histo'].SetColLabelValue(1, "Velocity")
		#self.data['histo'].SetColLabelValue(2, "Pressure")
		self.data['Lv'].SetColLabelValue(0, "Angle [deg]")
		self.data['Lv'].SetColLabelValue(1, "Lift [mm]")
		self.data['Cd'].SetColLabelValue(0, "Lift [mm]")
		self.data['Cd'].SetColLabelValue(1, "Cd")

    def setContextualHelp(self):
		for key in self.data:
			self.data[key].SetHelpText(help_valve[key])
# end of class formValve


