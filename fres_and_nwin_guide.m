classdef fres_and_nwin_guide < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        PropertiesPanel             matlab.ui.container.Panel
        WindowsnumberSpinnerLabel   matlab.ui.control.Label
        FrequencyresolutionSpinnerLabel  matlab.ui.control.Label
        FrequencyresolutionSpinner  matlab.ui.control.Spinner
        WindowsnumberSpinner        matlab.ui.control.Spinner
        CancelButton                matlab.ui.control.Button
        OkButton                    matlab.ui.control.Button
    end

    
    properties (Access = private)
        Property % Description
    end
    
    properties (Access = public)
        frequency_resolution % Resolution frequency
        number_window % number's windows
    end
    

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
        end

        % Button pushed function: CancelButton
        function CancelButtonPushed(app, event)
            
            uiresume(app.UIFigure);
            close();
        end

        % Button pushed function: OkButton
        function OkButtonPushed(app, event)
            fres = app.FrequencyresolutionSpinner.Value;
            nwin = app.WindowsnumberSpinner.Value;
            uiresume(app.UIFigure);
            
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 318 237];
            app.UIFigure.Name = 'UI Figure';

            % Create PropertiesPanel
            app.PropertiesPanel = uipanel(app.UIFigure);
            app.PropertiesPanel.Title = 'Properties';
            app.PropertiesPanel.Position = [32 67 258 136];

            % Create WindowsnumberSpinnerLabel
            app.WindowsnumberSpinnerLabel = uilabel(app.PropertiesPanel);
            app.WindowsnumberSpinnerLabel.HorizontalAlignment = 'right';
            app.WindowsnumberSpinnerLabel.Position = [32 36 104 22];
            app.WindowsnumberSpinnerLabel.Text = 'Window''s number:';

            % Create WindowsnumberSpinner
            app.WindowsnumberSpinner = uispinner(app.PropertiesPanel);
            app.WindowsnumberSpinner.Limits = [0 Inf];
            app.WindowsnumberSpinner.Position = [151 36 71 22];

            % Create FrequencyresolutionSpinnerLabel
            app.FrequencyresolutionSpinnerLabel = uilabel(app.PropertiesPanel);
            app.FrequencyresolutionSpinnerLabel.HorizontalAlignment = 'right';
            app.FrequencyresolutionSpinnerLabel.Position = [15 78 121 22];
            app.FrequencyresolutionSpinnerLabel.Text = 'Frequency resolution:';

            % Create FrequencyresolutionSpinner
            app.FrequencyresolutionSpinner = uispinner(app.PropertiesPanel);
            app.FrequencyresolutionSpinner.Step = 0.1;
            app.FrequencyresolutionSpinner.Position = [151 78 71 22];
            app.FrequencyresolutionSpinner.Value = 0.1;

            % Create CancelButton
            app.CancelButton = uibutton(app.UIFigure, 'push');
            app.CancelButton.ButtonPushedFcn = createCallbackFcn(app, @CancelButtonPushed, true);
            app.CancelButton.Position = [211 22 79 22];
            app.CancelButton.Text = 'Cancel';

            % Create OkButton
            app.OkButton = uibutton(app.UIFigure, 'push');
            app.OkButton.ButtonPushedFcn = createCallbackFcn(app, @OkButtonPushed, true);
            app.OkButton.Position = [116 22 85 22];
            app.OkButton.Text = 'Ok';
        end
    end

    methods (Access = public)

        % Construct app
        function app = fres_and_nwin_guide

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end