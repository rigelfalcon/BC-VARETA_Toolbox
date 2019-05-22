classdef freqresol_maxfreq_samplfreq_guide < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        PropertiesPanel                matlab.ui.container.Panel
        SamplingfrequencySpinnerLabel  matlab.ui.control.Label
        SamplingfrequencySpinner       matlab.ui.control.Spinner
        FrequencyresolutionSpinnerLabel  matlab.ui.control.Label
        FrequencyresolutionSpinner     matlab.ui.control.Spinner
        MaximumfrequencySpinnerLabel   matlab.ui.control.Label
        MaximumfrequencySpinner        matlab.ui.control.Spinner
        CancelButton                   matlab.ui.control.Button
        OkButton                       matlab.ui.control.Button
    end

    
    properties (Access = private)
        Property % Description
    end
    
    properties (Access = public)
        canceled
        frequency_resolution % Resolution frequency
        sampling_frequency % Samplin frequency
        max_frequency % Max frequency
        
    end
    

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
        end

        % Button pushed function: CancelButton
        function CancelButtonPushed(app, event)
            app.canceled = true;
            uiresume(app.UIFigure);
            close();
        end

        % Button pushed function: OkButton
        function OkButtonPushed(app, event)
            app.canceled = false;
            properties_file = strcat('properties',filesep,'properties.xml');
            root_tab =  'properties';
            
            app.frequency_resolution = app.FrequencyresolutionSpinner.Value;
            app.sampling_frequency = app.SamplingfrequencySpinner.Value;
            app.max_frequency = app.MaximumfrequencySpinner.Value;
            
            parameters = ["freq_resol","samp_freq","max_freq"];
            values = [app.frequency_resolution,app.sampling_frequency,app.max_frequency];
            
            change_xml_parameter(properties_file,root_tab,parameters,values);
            
            uiresume(app.UIFigure);
            
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 318 284];
            app.UIFigure.Name = 'UI Figure';

            % Create PropertiesPanel
            app.PropertiesPanel = uipanel(app.UIFigure);
            app.PropertiesPanel.Title = 'Properties';
            app.PropertiesPanel.Position = [32 73 258 177];

            % Create SamplingfrequencySpinnerLabel
            app.SamplingfrequencySpinnerLabel = uilabel(app.PropertiesPanel);
            app.SamplingfrequencySpinnerLabel.HorizontalAlignment = 'right';
            app.SamplingfrequencySpinnerLabel.Position = [21 77 115 22];
            app.SamplingfrequencySpinnerLabel.Text = 'Sampling frequency:';

            % Create SamplingfrequencySpinner
            app.SamplingfrequencySpinner = uispinner(app.PropertiesPanel);
            app.SamplingfrequencySpinner.Step = 0.1;
            app.SamplingfrequencySpinner.Limits = [0 Inf];
            app.SamplingfrequencySpinner.Position = [151 77 71 22];
            app.SamplingfrequencySpinner.Value = 200;

            % Create FrequencyresolutionSpinnerLabel
            app.FrequencyresolutionSpinnerLabel = uilabel(app.PropertiesPanel);
            app.FrequencyresolutionSpinnerLabel.HorizontalAlignment = 'right';
            app.FrequencyresolutionSpinnerLabel.Position = [15 119 121 22];
            app.FrequencyresolutionSpinnerLabel.Text = 'Frequency resolution:';

            % Create FrequencyresolutionSpinner
            app.FrequencyresolutionSpinner = uispinner(app.PropertiesPanel);
            app.FrequencyresolutionSpinner.Step = 0.1;
            app.FrequencyresolutionSpinner.Position = [151 119 71 22];
            app.FrequencyresolutionSpinner.Value = 0.5;

            % Create MaximumfrequencySpinnerLabel
            app.MaximumfrequencySpinnerLabel = uilabel(app.PropertiesPanel);
            app.MaximumfrequencySpinnerLabel.HorizontalAlignment = 'right';
            app.MaximumfrequencySpinnerLabel.Position = [19 30 117 22];
            app.MaximumfrequencySpinnerLabel.Text = 'Maximum frequency:';

            % Create MaximumfrequencySpinner
            app.MaximumfrequencySpinner = uispinner(app.PropertiesPanel);
            app.MaximumfrequencySpinner.Step = 0.1;
            app.MaximumfrequencySpinner.Limits = [0 Inf];
            app.MaximumfrequencySpinner.Position = [151 30 71 22];
            app.MaximumfrequencySpinner.Value = 32;

            % Create CancelButton
            app.CancelButton = uibutton(app.UIFigure, 'push');
            app.CancelButton.ButtonPushedFcn = createCallbackFcn(app, @CancelButtonPushed, true);
            app.CancelButton.Position = [211 32 79 22];
            app.CancelButton.Text = 'Cancel';

            % Create OkButton
            app.OkButton = uibutton(app.UIFigure, 'push');
            app.OkButton.ButtonPushedFcn = createCallbackFcn(app, @OkButtonPushed, true);
            app.OkButton.Position = [116 32 85 22];
            app.OkButton.Text = 'Ok';
        end
    end

    methods (Access = public)

        % Construct app
        function app = freqresol_maxfreq_samplfreq_guide

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