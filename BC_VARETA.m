classdef BC_VARETA < matlab.apps.AppBase
    
    % Properties that correspond to app components
    properties (Access = public)
        BCVARETAUIFigure          matlab.ui.Figure
        FileMenu                  matlab.ui.container.Menu
        ExitMenu                  matlab.ui.container.Menu
        ToolsMenu                 matlab.ui.container.Menu
        CreateDatasStructureMenu  matlab.ui.container.Menu
        DatasAnalizeMenu          matlab.ui.container.Menu
        HelpMenu                  matlab.ui.container.Menu
        TextArea                  matlab.ui.control.TextArea
    end
    
    
    methods (Access = private)
        
        function setPromptFcn(app,jTextArea,eventData,newPrompt)
            % Prevent overlapping reentry due to prompt replacement
            persistent inProgress
            if isempty(inProgress)
                inProgress = 1;  %#ok unused
            else
                return;
            end
            
            try
                % *** Prompt modification code goes here ***
                cwText = char(jTextArea.getText);
                app.TextArea.Value = cwText;
                % force prompt-change callback to fizzle-out...
                pause(0.02);
            catch
                % Never mind - ignore errors...
            end
            
            % Enable new callbacks now that the prompt has been modified
            inProgress = [];
            
        end  % setPromptFcn
        
    end
    
    
    methods (Access = private)
        
        % Code that executes after component creation
        function startupFcn(app)
            try
                
                jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
                jCmdWin = jDesktop.getClient('Command Window');
                jTextArea = jCmdWin.getComponent(0).getViewport.getView;
                set(jTextArea,'CaretUpdateCallback',@app.setPromptFcn)
            catch
                warndlg('fatal error');
            end
        end
        
        % Menu selected function: DatasAnalizeMenu
        function DatasAnalizeMenuSelected(app, event)
            Main;
            msgbox('Completed operation!!!','Info');
        end
        
        % Menu selected function: CreateDatasStructureMenu
        function CreateDatasStructureMenuSelected(app, event)
            folder = uigetdir('tittle','Select the Source Folder');
            if(folder==0)
                return;
            end
            create_data_structure(folder);
            msgbox('Completed operation!!!','Info');
        end
        
        % Callback function
        function ButtonPushed(app, event)
            jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
            jCmdWin = jDesktop.getClient('Command Window');
            jTextArea = jCmdWin.getComponent(0).getViewport.getView;
            cwText = char(jTextArea.getText);
            
            set(jTextArea,'CaretUpdateCallback',@myUpdateFcn)
            
        end
        
        % Menu selected function: ExitMenu
        function ExitMenuSelected(app, event)
            delete(app);
        end
    end
    
    % App initialization and construction
    methods (Access = private)
        
        % Create UIFigure and components
        function createComponents(app)
            
            % Create BCVARETAUIFigure
            app.BCVARETAUIFigure = uifigure;
            app.BCVARETAUIFigure.Color = [0.9412 0.9412 0.9412];
            app.BCVARETAUIFigure.Colormap = [0.2431 0.149 0.6588;0.251 0.1647 0.7059;0.2588 0.1804 0.7529;0.2627 0.1961 0.7961;0.2706 0.2157 0.8353;0.2745 0.2353 0.8706;0.2784 0.2549 0.898;0.2784 0.2784 0.9216;0.2824 0.302 0.9412;0.2824 0.3216 0.9569;0.2784 0.3451 0.9725;0.2745 0.3686 0.9843;0.2706 0.3882 0.9922;0.2588 0.4118 0.9961;0.2431 0.4353 1;0.2196 0.4588 0.9961;0.1961 0.4863 0.9882;0.1843 0.5059 0.9804;0.1804 0.5294 0.9686;0.1765 0.549 0.9529;0.1686 0.5686 0.9373;0.1529 0.5922 0.9216;0.1451 0.6078 0.9098;0.1373 0.6275 0.898;0.1255 0.6471 0.8902;0.1098 0.6627 0.8745;0.0941 0.6784 0.8588;0.0706 0.6941 0.8392;0.0314 0.7098 0.8157;0.0039 0.7216 0.7922;0.0078 0.7294 0.7647;0.0431 0.7412 0.7412;0.098 0.749 0.7137;0.1412 0.7569 0.6824;0.1725 0.7686 0.6549;0.1922 0.7765 0.6235;0.2157 0.7843 0.5922;0.2471 0.7922 0.5569;0.2902 0.7961 0.5176;0.3412 0.8 0.4784;0.3922 0.8039 0.4353;0.4471 0.8039 0.3922;0.5059 0.8 0.349;0.5608 0.7961 0.3059;0.6157 0.7882 0.2627;0.6706 0.7804 0.2235;0.7255 0.7686 0.1922;0.7725 0.7608 0.1647;0.8196 0.749 0.1529;0.8627 0.7412 0.1608;0.902 0.7333 0.1765;0.9412 0.7294 0.2118;0.9725 0.7294 0.2392;0.9961 0.7451 0.2353;0.9961 0.7647 0.2196;0.9961 0.7882 0.2039;0.9882 0.8118 0.1882;0.9804 0.8392 0.1765;0.9686 0.8627 0.1647;0.9608 0.8902 0.1529;0.9608 0.9137 0.1412;0.9647 0.9373 0.1255;0.9686 0.9608 0.1059;0.9765 0.9843 0.0824];
            app.BCVARETAUIFigure.Position = [100 100 679 459];
            app.BCVARETAUIFigure.Name = 'BC-VARETA';
            
            % Create FileMenu
            app.FileMenu = uimenu(app.BCVARETAUIFigure);
            app.FileMenu.Text = 'File';
            
            % Create ExitMenu
            app.ExitMenu = uimenu(app.FileMenu);
            app.ExitMenu.MenuSelectedFcn = createCallbackFcn(app, @ExitMenuSelected, true);
            app.ExitMenu.Text = 'Exit';
            
            % Create ToolsMenu
            app.ToolsMenu = uimenu(app.BCVARETAUIFigure);
            app.ToolsMenu.Text = 'Tools';
            
            % Create CreateDatasStructureMenu
            app.CreateDatasStructureMenu = uimenu(app.ToolsMenu);
            app.CreateDatasStructureMenu.MenuSelectedFcn = createCallbackFcn(app, @CreateDatasStructureMenuSelected, true);
            app.CreateDatasStructureMenu.Text = 'Create Data''s Structure';
            
            % Create DatasAnalizeMenu
            app.DatasAnalizeMenu = uimenu(app.ToolsMenu);
            app.DatasAnalizeMenu.MenuSelectedFcn = createCallbackFcn(app, @DatasAnalizeMenuSelected, true);
            app.DatasAnalizeMenu.Text = 'Data''s Analize';
            
            % Create HelpMenu
            app.HelpMenu = uimenu(app.BCVARETAUIFigure);
            app.HelpMenu.Text = 'Help';
            
            % Create TextArea
            app.TextArea = uitextarea(app.BCVARETAUIFigure);
            app.TextArea.Position = [29 21 625 391];
        end
    end
    
    methods (Access = public)
        
        % Construct app
        function app = BC_VARETA
            
            % Create and configure components
            createComponents(app)
            
            % Register the app with App Designer
            registerApp(app, app.BCVARETAUIFigure)
            
            % Execute the startup function
            runStartupFcn(app, @startupFcn)
            
            if nargout == 0
                clear app
            end
        end
        
        % Code that executes before app deletion
        function delete(app)
            
            % Delete UIFigure when app is deleted
            delete(app.BCVARETAUIFigure)
        end
    end
end