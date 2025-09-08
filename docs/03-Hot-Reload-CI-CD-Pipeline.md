# Hot Reload CI/CD Pipeline

This project includes automated CI/CD pipelines for building and deploying the Godot game to multiple platforms.

## Workflows

### 1. Continuous Integration (`ci.yml`)
- **Trigger**: Push or pull request to main/master/develop branches
- **Purpose**: Test builds to ensure the project compiles correctly
- **Platforms**: Web and Windows (quick validation)

### 2. Build and Release (`build-and-release.yml`)
- **Trigger**: 
  - Git tags following semantic versioning (e.g., `v1.0.0`, `v2.1.3`)
  - Manual workflow dispatch with version input
- **Purpose**: Build for all platforms and create GitHub releases
- **Platforms**: Web, Windows, Linux, macOS
- **Output**: ZIP/TAR.GZ files attached to GitHub releases

### 3. Deploy to GitHub Pages (`deploy-pages.yml`)
- **Trigger**: 
  - Push to main/master branch
  - Manual workflow dispatch
- **Purpose**: Deploy web version to GitHub Pages for easy access
- **Output**: Playable game at `https://[username].github.io/[repository-name]`

## How to Create a Release

### Method 1: Git Tags (Recommended)
1. Commit and push your changes to the main branch
2. Create and push a git tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
3. The workflow will automatically trigger and create a release

### Method 2: Manual Dispatch
1. Go to the Actions tab in your GitHub repository
2. Select "Build and Release" workflow
3. Click "Run workflow"
4. Enter the version (e.g., `v1.0.0`)
5. Click "Run workflow"

## Export Presets

The project includes export presets for:
- **Web**: Builds HTML5 version for browsers
- **Windows Desktop**: Builds .exe for Windows (x86_64)
- **Linux/X11**: Builds executable for Linux (x86_64)
- **macOS**: Builds .app bundle for macOS (universal binary)

## GitHub Pages Setup

To enable GitHub Pages deployment:
1. Go to your repository settings
2. Navigate to "Pages" section
3. Set Source to "GitHub Actions"
4. Push to main/master branch to trigger deployment

## File Structure

After a successful build, the following structure is created:
```
build/
├── web/           # Web build (HTML5)
├── windows/       # Windows build (.exe)
├── linux/         # Linux build (executable)
└── mac/           # macOS build (.zip with .app)
```

## Requirements

- Godot 4.4-stable
- Export templates are automatically downloaded by the CI
- No additional setup required - everything runs in containers

## Troubleshooting

### Build Failures
- Check that `export_presets.cfg` has all required presets
- Ensure `project.godot` is properly configured
- Verify that all required assets are included in the repository

### Missing Platforms
- Add missing export presets in Godot editor
- Update `export_presets.cfg` with new platform configurations
- Modify workflow files to include additional platforms

### GitHub Pages Issues
- Ensure repository settings have Pages enabled
- Check that the workflow has proper permissions
- Verify the web build includes all necessary files

## Customization

### Changing Godot Version
Update the `GODOT_VERSION` environment variable in workflow files:
```yaml
env:
  GODOT_VERSION: 4.4-stable  # Change this to your desired version
```

### Adding New Platforms
1. Add export preset in Godot editor
2. Update `export_presets.cfg`
3. Add new job in `build-and-release.yml`
4. Update release creation steps

### Custom Build Scripts
You can add pre/post-build steps in the workflow files, such as:
- Asset optimization
- Automated testing
- Custom packaging
- Distribution to other platforms (Steam, itch.io, etc.)