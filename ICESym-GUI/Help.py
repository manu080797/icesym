# -*- coding: utf-8 -*-
# generated by wxGlade 0.6.3 on Mon May 18 09:43:57 2009

import wx
import wx.html
from help_texts import html_pages, ordered_pages_pre, ordered_pages_post
# begin wxGlade: dependencies
# end wxGlade

# begin wxGlade: extracode

# end wxGlade

class Help(wx.Frame):
    itemsTree = dict()
    def __init__(self, *args, **kwds):
        # begin wxGlade: Home.__init__
        kwds["style"] = wx.DEFAULT_FRAME_STYLE
        wx.Frame.__init__(self, *args, **kwds)
        self.window_1 = wx.SplitterWindow(self, -1, style=wx.SP_3DBORDER|wx.SP_BORDER|wx.SP_LIVE_UPDATE|wx.WANTS_CHARS)
        self.window_1_pane_2 = wx.ScrolledWindow(self.window_1, -1, style=wx.TAB_TRAVERSAL|wx.WANTS_CHARS)
        self.window_1_pane_1 = wx.ScrolledWindow(self.window_1, -1, style=wx.TAB_TRAVERSAL|wx.WANTS_CHARS)
        icono = wx.EmptyIcon()
        icono.CopyFromBitmap(wx.Image("images/icesIcone.png",wx.BITMAP_TYPE_PNG).ConvertToBitmap())
        self.SetIcon(icono) 
        self.html = wx.html.HtmlWindow(self.window_1_pane_2)
        if "gtk2" in wx.PlatformInfo:
            self.html.SetStandardFonts()
        self.html.LoadPage("html/index.html")

        # Tool Bar
        self.toolbar = wx.ToolBar(self, -1)
        self.SetToolBar(self.toolbar)
        self.toolbar.AddTool(1, "Tree Help", wx.ArtProvider.GetBitmap(wx.ART_GO_HOME, wx.ART_OTHER), wx.NullBitmap, wx.ITEM_NORMAL, "Tree Help", "See the tree help")
        self.toolbar.AddTool(2, "Previous", wx.ArtProvider.GetBitmap(wx.ART_GO_BACK, wx.ART_OTHER), wx.NullBitmap, wx.ITEM_NORMAL, "Previous", "Previous Page")
        self.toolbar.AddTool(3, "Next", wx.ArtProvider.GetBitmap(wx.ART_GO_FORWARD, wx.ART_OTHER), wx.NullBitmap, wx.ITEM_NORMAL, "Next", "Next Page")
        # Tool Bar end

# ---------------- START tree config --------------------------------------------------- #

        self.tree = wx.TreeCtrl(self.window_1_pane_1,-1, wx.DefaultPosition, wx.DefaultSize,wx.TR_HAS_BUTTONS)
       
        isz = (16,16)
        il = wx.ImageList(isz[0], isz[1])
        self.fldridx     = il.Add(wx.ArtProvider.GetBitmap(wx.ART_HELP_BOOK, wx.ART_OTHER, isz))
        self.fldropenidx = il.Add(wx.ArtProvider.GetBitmap(wx.ART_HELP_SIDE_PANEL, wx.ART_OTHER, isz))
        self.fileidx     = il.Add(wx.ArtProvider.GetBitmap(wx.ART_NORMAL_FILE, wx.ART_OTHER, isz))
        self.tipdx       = il.Add(wx.ArtProvider.GetBitmap(wx.ART_TIP,   wx.ART_OTHER, isz))
        #smileidx    = il.Add(images.Smiles.GetBitmap())

        self.tree.SetImageList(il)
        self.il = il

        # NOTE:  For some reason tree items have to have a data object in
        #        order to be sorted.  Since our compare just uses the labels
        #        we don't need any real data, so we'll just use None below for
        #        the item data.

        self.root = self.tree.AddRoot("Index")
        self.tree.SetPyData(self.root, "html/index.html")
        self.tree.SetItemImage(self.root, self.fldridx, wx.TreeItemIcon_Normal)
        self.tree.SetItemImage(self.root, self.fldropenidx, wx.TreeItemIcon_Expanded)
  
        self.Bind(wx.EVT_TOOL, self.Ontree, id=1)
        self.Bind(wx.EVT_TOOL, self.OnBack, id=2)
        self.Bind(wx.EVT_TOOL, self.OnForward, id=3)

        self.tree.Bind(wx.EVT_LEFT_DCLICK, self.OnLeftDClick)
        self.tree.Bind(wx.EVT_RIGHT_DOWN, self.OnRightDown)
        self.tree.Bind(wx.EVT_RIGHT_UP, self.OnRightUp)

        self.initTree()
        self.tree.Expand(self.root)

# ---------------- END tree config --------------------------------------------------- #

        self.__set_properties()
        self.__do_layout()


    def __set_properties(self):
        # begin wxGlade: Home.__set_properties
        self.SetTitle("ICESym-GUI User Help")
        self.SetSize(wx.DLG_SZE(self, (314, 314)))
        self.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.html.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.toolbar.Realize()
        self.window_1_pane_1.SetScrollRate(10, 10)
        self.window_1_pane_2.SetScrollRate(10, 10)
        self.window_1.SetMinSize(wx.DLG_SZE(self.window_1, (408, 200)))
        # end wxGlade

    def __do_layout(self):
        # begin wxGlade: Home.__do_layout
        sizer_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_3 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_3.Add(self.tree, 1, wx.EXPAND, 0)	
        self.window_1_pane_1.SetSizer(sizer_3)
        sizer_2.Add(self.html, 1, wx.EXPAND, 0)
        self.window_1_pane_2.SetSizer(sizer_2)
        self.window_1.SplitVertically(self.window_1_pane_1, self.window_1_pane_2, 111)
        sizer_1.Add(self.window_1, 1, wx.EXPAND, 0)
        self.SetSizer(sizer_1)
        sizer_1.SetSizeHints(self)
        self.Layout()
        # end wxGlade

    def Ontree(self, event):
		self.html.LoadPage('html/index.html')

# ---  BEGIN TREE CONTROL CODE -----#

####--------------------------------------------####

    def OnRightDown(self, event):
        pt = event.GetPosition();
        item, flags = self.tree.HitTest(pt)
        if item:
            #self.log.WriteText("OnRightClick: %s, %s, %s\n" %
            #                   (self.tree.GetItemText(item), type(item), item.__class__))
            self.tree.SelectItem(item)


    def OnRightUp(self, event):
        pt = event.GetPosition();
        item, flags = self.tree.HitTest(pt)
        if item:        
            #self.log.WriteText("OnRightUp: %s (manually starting label edit)\n"
            #                   % self.tree.GetItemText(item))
            self.tree.EditLabel(item)


    def OnLeftDClick(self, event):
		pt = event.GetPosition();
		item, flags = self.tree.HitTest(pt)
		if item:
			page = self.tree.GetItemPyData(item)
			self.html.LoadFile(page)

    def OnSize(self, event):
        w,h = self.GetClientSizeTuple()
        self.tree.SetDimensions(0, 0, w, h)


    def initTree(self):
		self.childs = dict()
		self.pre = self.tree.AppendItem(self.root, "Pre-Process")
		self.tree.SetPyData(self.pre, "html/indexPre.html")
		self.post = self.tree.AppendItem(self.root, "PostProcess")
		self.tree.SetPyData(self.post, "html/indexPost.html")
		self.tree.SetItemImage(self.pre, self.fldridx, wx.TreeItemIcon_Normal)
		self.tree.SetItemImage(self.pre, self.fldropenidx, wx.TreeItemIcon_Expanded)
		self.tree.SetItemImage(self.post, self.fldridx, wx.TreeItemIcon_Normal)
		self.tree.SetItemImage(self.post, self.fldropenidx, wx.TreeItemIcon_Expanded)
		for name in ordered_pages_pre:
			self.itemsTree[name] = dict()
			self.childs[name] = self.tree.AppendItem(self.pre, name)
			self.tree.SetPyData(self.childs[name], html_pages[name]) 
			self.tree.SetItemImage(self.childs[name], self.fldridx, wx.TreeItemIcon_Normal)
			self.tree.SetItemImage(self.childs[name], self.fldropenidx, wx.TreeItemIcon_Expanded)

		for name in ordered_pages_post:
			self.itemsTree[name] = dict()
			self.childs[name] = self.tree.AppendItem(self.post, name)
			self.tree.SetPyData(self.childs[name], html_pages[name]) 
			self.tree.SetItemImage(self.childs[name], self.fldridx, wx.TreeItemIcon_Normal)
			self.tree.SetItemImage(self.childs[name], self.fldropenidx, wx.TreeItemIcon_Expanded)

    def OnBack(self,event):
		if self.html.HistoryCanBack():
			self.html.HistoryBack()
		else:
			print "not back"

    def OnForward(self,event):
		if self.html.HistoryCanForward():
			self.html.HistoryForward()
		else:
			print "not forward"
