function results = runMATLABTests()
    import matlab.unittest.TestSuite
    import matlab.unittest.TestRunner
    import matlab.unittest.plugins.CodeCoveragePlugin
    import matlab.unittest.plugins.codecoverage.CoberturaFormat

    % Add utils folder to path
    addpath('utils');

    % Create a test suite
    suite = TestSuite.fromFolder('tests');

    % Create a test runner
    runner = TestRunner.withTextOutput;

    % Add Code Coverage Plugin
    coverageFile = 'coverage.xml';
    
    % Create the Cobertura format reporter
    coberturaFormat = CoberturaFormat(coverageFile);
    
    % Create the plugin with the correct syntax
    plugin = CodeCoveragePlugin.forFolder('utils', 'IncludingSubfolders', true);
    
    % Create a plugin that produces the Cobertura report
    import matlab.unittest.plugins.codecoverage.CoverageReport
    reportPlugin = matlab.unittest.plugins.codecoverage.CoverageReport(coberturaFormat);
    
    % Add the plugins to the runner
    runner.addPlugin(plugin);
    runner.addPlugin(reportPlugin);

    % Run the tests
    results = runner.run(suite);
    disp(results);
end
