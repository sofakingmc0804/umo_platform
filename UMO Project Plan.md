# UMO Platform: The Master Build Plan (Definitive Edition v3.0)

**Document Purpose:** To provide a complete, granular, and sequential set of instructions for an AI agent to build the UMO Platform, from initial setup to a launch-ready application. This plan is based entirely on the UMO‑Platform – Launch‑Ready Comprehensive Specification Addendum (Revision 2025‑06‑08) and integrates a professional development workflow with comprehensive error handling, validation, and accountability measures.

## Enhanced Guiding Principles

**Spec is Law:** The specification document is immutable. Every task maps directly to a section of the spec. There will be no deviation or generalization.

**Agent Accountability:** Every code change must include validation steps, error handling, and rollback procedures. The agent must provide evidence of completion including test results, code snippets, and performance metrics.

**Test-Driven Development (TDD):** Every feature implemented will be accompanied by unit tests, integration tests, and end-to-end tests. Minimum 80% code coverage required.

**Iterative Value Delivery:** Build in logical phases with working deliverables at each sprint completion.

**Human-in-the-Loop (HITL) with Clear Handoffs:** Explicit checkpoints with detailed completion reports and demonstration requirements.

**Error Recovery & Rollback:** Every sprint includes rollback procedures and error recovery protocols.

**Code-Coverage Policy:**  
• Core business / security logic ≥ 90%  
• Supporting utilities ≥ 80%  
• Pure-UI widgets ≥ 60%  
The CI gate is parameterized – tiers above may ship with lower coverage only after risk sign-off.

## Agent Escalation & Recovery Protocol

### Definition of "Stuck"
A state is defined as "stuck" if the agent fails to make a test pass or resolve an error after three consecutive, distinct attempts.

### Mandatory Protocol When Stuck
1. After the third failure, the agent MUST stop immediately.
2. It MUST create a new git branch named `debug/[sprint_id]-failure`.
3. It MUST commit the failing code and test results.
4. It MUST generate a "Failure Report" in `reports/FAIL_[sprint_id].md` containing:
   - (a) The task objective
   - (b) The list of attempted solutions
   - (c) The exact final error message and stack trace
5. It MUST present this report to the Human-in-the-Loop and await new instructions.

## Agent Workflow Protocols

### Pre-Task Validation Checklist
```yaml
before_each_task:
  - verify_environment_state: "Check all dependencies and services are running"
  - backup_current_state: "Create git commit with descriptive message"
  - validate_prerequisites: "Ensure previous tasks completed successfully"
  - estimate_completion_time: "Provide realistic time estimate"
  - identify_risk_factors: "List potential blockers or issues"
```

### Task Execution Protocol
```yaml
during_task_execution:
  - incremental_commits: "Commit every logical unit of work"
  - continuous_testing: "Run tests after each significant change"
  - documentation_updates: "Update relevant docs inline with code changes"
  - performance_monitoring: "Track resource usage and performance impact"
  - error_logging: "Capture and categorize all errors encountered"
```

### Post-Task Validation Requirements
```yaml
after_each_task:
  - run_full_test_suite: "Execute all relevant tests and report results"
  - code_quality_check: "Run linting, formatting, and static analysis"
  - security_scan: "Check for security vulnerabilities"
  - performance_benchmark: "Measure and compare performance metrics"
  - documentation_review: "Ensure all changes are documented"
  - demo_preparation: "Prepare screenshots/videos for human review"
```

### Sprint Completion Report Template
```markdown
## Sprint [X.X] Completion Report

### Tasks Completed
- [ ] Task X.X.1: [Description] - ✅ PASSED
- [ ] Task X.X.2: [Description] - ✅ PASSED

### Test Results
- Unit Tests: [X/Y] passed (Z% coverage)
- Integration Tests: [X/Y] passed
- E2E Tests: [X/Y] passed
- Performance Tests: [Results within acceptable range]

### Code Quality Metrics
- Linting: No errors
- Security Scan: No high/critical vulnerabilities
- Performance: [Specific metrics vs benchmarks]

### Deliverables
- [Links to committed code]
- [Screenshots/videos of working features]
- [Updated documentation]

### Design Rationale & Alternatives Considered
- Why the chosen approach: [2-5 bullets explaining implementation decisions]
- Alternative(s) rejected: [List alternatives and why they were not chosen]

### Human-Led Code Review Checklist
- [ ] Readability: Is the code clear and idiomatic?
- [ ] Algorithmic Efficiency: Is the chosen algorithm appropriate for the expected scale?
- [ ] Error Handling: Are edge cases and potential nulls handled gracefully?
- [ ] Security Implications: Are there any potential security vulnerabilities?
- [ ] Architecture Conformity: Does the code follow established patterns?

### Issues Encountered & Resolutions
- [List any problems and how they were resolved]

### Rollback Procedure (if needed)
- [Step-by-step instructions to undo changes]

### Next Sprint Prerequisites
- [What must be verified before proceeding]
```

## Phase 0: Project Foundation & Cloud Setup (Enhanced)

### Sprint 0.0: Local Environment Provisioning  <!-- NEW -->
- **Overall Goal:** Ensure all required SDKs/CLIs are installed and available in PATH.
- **Ownership:** Human (manual install) + Agent (verification via scripts).
- **Blocking:** Sprint 0.1+ cannot start until all checks pass.

**Task 0.0.1:** Install Flutter SDK  
Windows (PowerShell):  
```powershell
winget install --id=Flutter.Flutter
# OR
choco install flutter
```
macOS (zsh):  
```bash
brew install --cask flutter
```
Linux (bash):  
```bash
sudo snap install flutter --classic
```
Add `<flutter-dir>\bin` to PATH and run `flutter doctor`.

**Task 0.0.2:** Install Android/Visual Studio / Xcode dependencies  
- Windows: `winget install Microsoft.VisualStudio.2022.Community -e --source winget`
  → Include “Desktop development with C++”.
- macOS: `xcode-select --install`.
- Linux: `sudo apt-get install clang cmake ninja-build libgtk-3-dev`.

**Task 0.0.3:** Install Firebase CLI  
```bash
npm install -g firebase-tools
firebase --version
```

**Task 0.0.4:** Verify environment with automated script  
```bash
# Windows
powershell -ExecutionPolicy Bypass -File tools/check_environment.ps1
# macOS/Linux
bash tools/check_environment.sh
```
> The scripts now **print OS-specific installation hints** for any missing tool and abort early, ensuring the agent or human can resolve issues without manual troubleshooting.
> The verification scripts are **self-healing**: if a required tool is missing they automatically install it (winget/brew/snap/apt/npm) and then re-run the check. No manual intervention is expected unless the install itself fails.

**Validation Requirements:**  
- `flutter doctor -v` shows no unresolved issues.  
- `firebase --version` outputs a semantic version.  
- Scripts exit with code 0.  
- **Architectural Adherence Check:** N/A (setup sprint).

> NOTE: Pre-Task Validation Checklist now implicitly calls `tools/check_environment.*` in its `verify_environment_state` step.

### Sprint 0.1: Initial Project Creation & Service Activation (Web Console)

#### Sprint Context & High-Level Directives
- **Overall Goal:** Provision Firebase project and enable core services
- **Immutable Constraint:** No CLI work in this sprint - manual console setup only
- **Security Constraint:** Use organizational Google account only
- **Deliverable Artifacts:** Service-enablement screenshots saved in `/evidence/0.1/`

**Objective:** To perform the one-time administrative setup of the project's cloud container.

**Agent Validation Requirements:**
- Verify Firebase project creation via Firebase Admin SDK
- Confirm all required services are enabled programmatically
- Test authentication flow with temporary test account
- **Architectural Adherence Check:** N/A (manual sprint)

**Task 0.1.1 (Human):** Go to the Firebase Console.
**Task 0.1.2 (Human):** Create a new Firebase project. Name it umo-platform-prod.
**Task 0.1.3 (Human):** Within the project dashboard, enable the following services:
- Authentication: Enable the Email/Password and Google sign-in methods.
- Firestore Database: Create a new database. Start in test mode.
- Storage: Enable Cloud Storage.
**Task 0.1.4 (Human):** Once complete, the project is ready to be linked from your local environment.

### Sprint 0.2: Flutter Project & Version Control Setup (Agent Task)

#### Sprint Context & High-Level Directives
- **Overall Goal:** Scaffold cross-platform Flutter project with baseline tooling
- **Architectural Constraint:** Project must compile for desktop AND web platforms
- **Tooling Constraint:** Git main branch default; follow Conventional Commits format
- **Design Constraint:** No UI implementation yet - theme file will be created in Sprint 1.0

**Objective:** To create the local Flutter project, initialize version control, and establish code quality standards within VS Code.

**Enhanced Task Specifications:**

**Task 0.2.1:** Create Flutter Project
```bash
# Agent must execute and validate
flutter create --org org.umo-platform --platforms=windows,macos,linux,web umo_platform
cd umo_platform
flutter doctor -v # Verify installation
flutter test # Ensure default tests pass
```
**Task 0.2.1.A (State Assertion):** Verify project structure exists with `ls -la` and confirm presence of `lib/`, `test/`, `pubspec.yaml`

**Task 0.2.2:** Initialize Git with Comprehensive Setup
```bash
git init
git remote add origin [REPO_URL]
# Create comprehensive .gitignore
echo "# Flutter specific
.dart_tool/
.packages
.pub-cache/
.pub/
build/
flutter_*.png

# IDE
.vscode/
.idea/
*.iml

# OS
.DS_Store
Thumbs.db

# Firebase
google-services.json
GoogleService-Info.plist
firebase_options.dart

# Environment
.env
.env.local
.env.production

# Coverage
coverage/
*.lcov" > .gitignore
```
**Task 0.2.2.B (State Assertion):** Run `git status` and verify output contains "On branch main" and "No commits yet"

**Task 0.2.3:** Create Comprehensive Documentation Structure
```markdown
# Files to create with specific content requirements:
README.md:
- Project description
- Setup instructions
- Development workflow
- Testing guidelines
- Contribution requirements

CONTRIBUTING.md:
- Code style guidelines
- Commit message format
- Pull request process
- DCO requirements
- Testing requirements

ARCHITECTURE.md:
- System architecture overview
- Technology stack rationale
- Data flow diagrams
- Security considerations

DEPLOYMENT.md:
- Build and deployment process
- Environment configuration
- Release checklist
- Rollback procedures
```

**Task 0.2.4:** Configure Development Environment
```yaml
# analysis_options.yaml - Strict linting configuration
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false

linter:
  rules:
    - always_declare_return_types
    - always_put_required_named_parameters_first
    - avoid_print
    - avoid_unnecessary_containers
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - require_trailing_commas
    - use_key_in_widget_constructors
```

**Task 0.2.5:** Create Architecture Check Script
```bash
# Create scripts/lint_architecture.sh
#!/bin/bash
echo "Checking for architectural violations..."
# Check for hardcoded colors
if grep -r "Color(0x" lib/ --include="*.dart" | grep -v "theme/"; then
  echo "ERROR: Hardcoded colors found outside theme files"
  exit 1
fi
# Check for direct service instantiation
if grep -r "= [A-Z][a-zA-Z]*Service(" lib/ --include="*.dart" | grep -v "provider"; then
  echo "ERROR: Direct service instantiation found"
  exit 1
fi
echo "Architecture check passed!"
```

**Validation Requirements:**
- All linting rules pass
- Default tests execute successfully
- Documentation renders correctly
- Git hooks are functional
- **Architectural Adherence Check:** Run `./scripts/lint_architecture.sh` and ensure it passes

### Sprint 0.3: Enhanced Firebase Integration & CI/CD

#### Sprint Context & High-Level Directives
- **Overall Goal:** Wire Firebase SDK and establish CI pipeline
- **Architectural Constraint:** Environment variables loaded via Config singleton, never via Platform.environment
- **Tool Constraint:** CI must be green before any further work proceeds
- **Security Constraint:** Never commit actual secrets, only templates

**Task 0.3.1:** Firebase Dependencies with Version Locking
```yaml
# pubspec.yaml additions with specific versions
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  firebase_analytics: ^10.7.4
  firebase_crashlytics: ^3.4.8
  firebase_performance: ^0.9.3+8
  flutter_dotenv: ^5.1.0

dev_dependencies:
  build_runner: ^2.4.7
  json_annotation: ^4.8.1
  json_serializable: ^6.7.1
  mockito: ^5.4.4
  integration_test:
    sdk: flutter
```

**Task 0.3.2:** Comprehensive CI/CD Pipeline
```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Verify formatting
        run: dart format --output=none --set-exit-if-changed .
      
      - name: Analyze project source
        run: flutter analyze --fatal-infos
      
      - name: Run unit tests
        run: flutter test --coverage
      
      - name: Check coverage threshold
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info | grep "lines" | grep -o '[0-9.]*%' | head -1 | tr -d '%')
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "Coverage $COVERAGE% is below 80% threshold"
            exit 1
          fi
      
      - name: Integration tests
        run: flutter test integration_test/
      
      - name: Security scan
        run: dart pub global activate dart_code_metrics && metrics analyze lib
      
      - name: Architecture check
        run: chmod +x ./scripts/lint_architecture.sh && ./scripts/lint_architecture.sh
```
**Task 0.3.2.A (State Assertion):** Parse `coverage/lcov.info` programmatically to confirm coverage ≥ 80% using `lcov --summary`

**Task 0.3.3:** Error Handling and Logging Framework
```dart
// lib/core/error_handling.dart
class UMOException implements Exception {
  final String message;
  final String code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const UMOException({
    required this.message,
    required this.code,
    this.originalError,
    this.stackTrace,
  });
}

class ErrorHandler {
  static void handleError(Object error, StackTrace stackTrace) {
    // Log to Firebase Crashlytics
    // Log to local file for debugging
    // Show user-friendly error message
  }
}
```

**Validation Requirements:**
- All CI checks pass
- Error handling framework functional
- Firebase connection verified
- Performance baseline established
- **Architectural Adherence Check:** Run `dart run tools/arch_check.dart` to verify no direct Firebase usage outside services

### Sprint 0.4: DevOps & Observability Foundation

#### Sprint Context & High-Level Directives
- **Overall Goal:** Establish observability infrastructure and secret management
- **Security Constraint:** Never commit real secrets; only .env.template
- **Performance Constraint:** Added logging must stay < 1% CPU in profile mode
- **Monitoring Constraint:** All critical paths must have performance traces

**Task 0.4.1 (Infra):** Provision Cloud Logging sink → BigQuery, create Grafana/Cloud Monitoring dashboard.
**Task 0.4.2 (Code):** Add `flutter_dotenv` and create `.env.template`, `.env.development`, `.env.production`.
```bash
# .env.template
FIREBASE_API_KEY=your_api_key_here
FIREBASE_AUTH_DOMAIN=your_auth_domain_here
FIREBASE_PROJECT_ID=your_project_id_here
```
**Task 0.4.2.A (State Assertion):** Verify `.env` is in `.gitignore` by running `git check-ignore .env` and confirming it returns `.env`

**Task 0.4.3 (CI):** Inject secrets in GitHub Actions:
```yaml
- name: Inject prod env
  run: echo "${{ secrets.PROD_ENV }}" > .env.production
```  
**Task 0.4.4 (Code):** `lib/core/config.dart` lazy-loads env vars and exposes typed getters.
```dart
// lib/core/config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static late Config _instance;
  
  static Future<void> initialize(String environment) async {
    await dotenv.load(fileName: '.env.$environment');
    _instance = Config._();
  }
  
  static Config get instance => _instance;
  
  Config._();
  
  String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  // ... other getters
}
```

**Validation Requirements:**
- Unit test that missing env throws exception
- CI warns if template & runtime keys diverge
- **Architectural Adherence Check:** Scan codebase to ensure no direct `dotenv.env` access outside Config class

## Phase 1: The MVP (Free Tier - Local Desktop App)

### Sprint 1.0: Design System & Theming Foundation

#### Sprint Context & High-Level Directives
- **Overall Goal:** Establish immutable UMO design system and theme
- **Design Constraint:** All colors and typography must come from UMOTheme; no inline styles allowed
- **Testing Constraint:** Golden tests are the source of truth for UI consistency
- **Architecture Constraint:** Theme must be accessible via Provider/Riverpod

**Task 1.0.1:** Create `lib/theme/umo_theme.dart` with ColorScheme, TextTheme, spacing constants.
```dart
// lib/theme/umo_theme.dart
class UMOTheme {
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: Color(0xFF1976D2),
    // ... complete color scheme
  );
  
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 96, fontWeight: FontWeight.w300),
    // ... complete text theme
  );
  
  static const double spacingUnit = 8.0;
  static const double spacingSmall = spacingUnit;
  static const double spacingMedium = spacingUnit * 2;
  static const double spacingLarge = spacingUnit * 3;
}
```

**Task 1.0.2:** Wire theme globally in `MaterialApp`.
**Task 1.0.3:** Create component gallery route `/theme_gallery` (debug mode only).
**Task 1.0.4 (Test):** Golden tests for primary widgets.
```bash
flutter test --update-goldens test/theme/theme_gallery_test.dart
```
**Task 1.0.4.A (State Assertion):** Verify golden files exist in `test/goldens/` directory

**Validation Requirements:**
- All theme values are used consistently
- No hardcoded colors or sizes in codebase
- Golden tests pass
- **Architectural Adherence Check:** Script ensures no `Color(0xFF...)` literals outside theme files

### Sprint 1.1: Data Models & Local Storage Layer

#### Sprint Context & High-Level Directives
- **Overall Goal:** Implement immutable domain models with SQLite persistence and migrations
- **Data Constraint:** Schema versioning via sqflite_migration is mandatory
- **Testing Constraint:** 100% coverage on model serialization/deserialization
- **Architecture Constraint:** No direct database access outside repository classes

**Task 1.1.1:** Data Models with Comprehensive Validation
```dart
// lib/models/conversation.dart
@freezed
class UMOConversation with _$UMOConversation {
  const factory UMOConversation({
    required String id,
    required String title,
    required DateTime created,
    required DateTime updated,
    required LLMProvider llmProvider,
    @Default([]) List<UMOMessage> messages,
    @Default([]) List<String> tags,
    String? organizationId,
    @Default(false) bool isArchived,
  }) = _UMOConversation;

  factory UMOConversation.fromJson(Map<String, dynamic> json) =>
      _$UMOConversationFromJson(json);
}

// Validation rules
class ConversationValidator {
  static ValidationResult validate(UMOConversation conversation) {
    final errors = <String>[];
    
    if (conversation.title.trim().isEmpty) {
      errors.add('Title cannot be empty');
    }
    
    if (conversation.title.length > 255) {
      errors.add('Title cannot exceed 255 characters');
    }
    
    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }
}
```

**Task 1.1.2:** Repository Pattern with Interface Segregation
```dart
// lib/repositories/conversation_repository.dart
abstract class ConversationRepository {
  Future<List<UMOConversation>> getConversations({int? limit, int? offset});
  Future<UMOConversation?> getConversation(String id);
  Future<String> createConversation(UMOConversation conversation);
  Future<void> updateConversation(UMOConversation conversation);
  Future<void> deleteConversation(String id);
  Future<List<UMOConversation>> searchConversations(String query);
}

class LocalConversationRepository implements ConversationRepository {
  // Implementation with comprehensive error handling
  // Enforce 10,000 conversation limit from spec
  // Include data integrity checks
  // Implement atomic transactions
}
```

**Task 1.1.3:** Add sqflite_migration manager
```dart
// lib/services/database_service.dart
class DatabaseService {
  static const String dbName = 'umo_platform.db';
  static const int dbVersion = 1;
  
  Future<Database> openDatabase() async {
    final path = await getDatabasesPath();
    return await openDatabase(
      join(path, dbName),
      version: dbVersion,
      onUpgrade: _runMigrations,
    );
  }
  
  Future<void> _runMigrations(Database db, int oldVersion, int newVersion) async {
    for (int i = oldVersion + 1; i <= newVersion; i++) {
      final migration = await rootBundle.loadString('assets/migrations/v$i.sql');
      await db.execute(migration);
    }
  }
}
```

**Task 1.1.4:** Create `assets/migrations/v1.sql`
```sql
-- v1.sql
CREATE TABLE conversations (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  llm_provider TEXT NOT NULL,
  is_archived INTEGER DEFAULT 0
);

CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  conversation_id TEXT NOT NULL,
  role TEXT NOT NULL,
  content TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  FOREIGN KEY (conversation_id) REFERENCES conversations(id)
);
```

**Task 1.1.5 (Test):** Migration test
```dart
test('database migration from v1 to v2', () async {
  // Create v1 database
  // Add test data
  // Run migration to v2
  // Verify data integrity and new schema
});
```

**Enhanced Validation Requirements:**
- All model classes have 100% test coverage
- Validation rules tested with edge cases
- Repository implements proper transaction handling
- Performance benchmarks for database operations
- Memory usage profiling for large datasets
- **Architectural Adherence Check:** Check for any direct `Database` access outside `LocalDatabaseService`

### Sprint 1.2: UI Architecture with Component Testing

#### Sprint Context & High-Level Directives
- **Overall Goal:** Build application shell with Riverpod state management
- **State Constraint:** No setState except in private widget helpers; all state via Riverpod
- **i18n Constraint:** All user-facing strings must use AppLocalizations
- **Design Constraint:** All styling must reference UMOTheme values

**Task 1.2.1:** State Management Architecture
```dart
// lib/providers/conversation_provider.dart
@riverpod
class ConversationNotifier extends _$ConversationNotifier {
  @override
  Future<List<UMOConversation>> build() async {
    return await ref.read(conversationRepositoryProvider).getConversations();
  }

  Future<void> createConversation(UMOConversation conversation) async {
    // Validate conversation
    final validationResult = ConversationValidator.validate(conversation);
    if (!validationResult.isValid) {
      throw UMOException(
        message: validationResult.errors.join(', '),
        code: 'VALIDATION_ERROR',
      );
    }

    // Check limits for free tier
    final currentCount = state.value?.length ?? 0;
    final subscriptionTier = ref.read(subscriptionProvider);
    
    if (subscriptionTier == SubscriptionTier.free && currentCount >= 10000) {
      throw UMOException(
        message: 'Free tier conversation limit reached',
        code: 'LIMIT_EXCEEDED',
      );
    }

    // Create conversation
    await ref.read(conversationRepositoryProvider).createConversation(conversation);
    ref.invalidateSelf();
  }
}
```

**Task 1.2.2:** Widget Testing Framework
```dart
// test/widgets/conversation_list_test.dart
void main() {
  group('ConversationList Widget Tests', () {
    testWidgets('displays conversations correctly', (tester) async {
      // Mock data setup
      final mockConversations = [
        UMOConversation(id: '1', title: 'Test Chat', /* ... */),
      ];

      // Widget setup with providers
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            conversationNotifierProvider.overrideWith(() => mockConversations),
          ],
          child: MaterialApp(home: ConversationList()),
        ),
      );

      // Assertions
      expect(find.text('Test Chat'), findsOneWidget);
      expect(find.byType(ConversationTile), findsNWidgets(1));
    });

    testWidgets('handles empty state', (tester) async {
      // Test empty state rendering
    });

    testWidgets('handles error state', (tester) async {
      // Test error state handling
    });

    testWidgets('handles loading state', (tester) async {
      // Test loading indicators
    });
  });
}
```

**Task 1.2.3:** Set up i18n
```yaml
# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

**Task 1.2.4:** Create initial translations
```json
// lib/l10n/app_en.arb
{
  "appTitle": "UMO Platform",
  "conversationListTitle": "Conversations",
  "newConversation": "New Conversation",
  "@appTitle": {
    "description": "The application title"
  }
}
```

**Task 1.2.5:** A11y implementation
- Add `semanticLabel` to all interactive widgets
- Wrap complex widgets with `Semantics`
- Test with screen reader

**Validation Requirements:**
- All tests pass with >80% coverage
- No hardcoded strings
- All interactive elements have semantic labels
- **Architectural Adherence Check:** Scan diff for hardcoded strings and missing `semanticLabel`

### Sprint 1.3: Hardware Detection & Basic LLM Connection

#### Sprint Context & High-Level Directives
- **Overall Goal:** Implement hardware profiling and local LLM connectivity
- **Performance Constraint:** Hardware detection must complete in <500ms
- **Architecture Constraint:** LLM connections must go through provider abstraction
- **Testing Constraint:** Mock hardware profiles for consistent testing

**Task 1.3.1:** Add `device_info_plus` package
**Task 1.3.2:** Implement hardware detection based on Spec Section 1.3
**Task 1.3.3:** Create Settings page displaying hardware profile
**Task 1.3.4:** Add local LLM connection form with test button
**Task 1.3.5 (Test):** Unit tests for `getOptimalSettings()` with mock profiles

**Validation Requirements:**
- Hardware detection works on all platforms
- LLM connection test provides clear feedback
- Settings are persisted correctly
- **Architectural Adherence Check:** Ensure no direct hardware API calls outside service layer

### Sprint 1.4: Chat Interface & Core Free Features

#### Sprint Context & High-Level Directives
- **Overall Goal:** Implement functional chat with all Free tier features
- **UX Constraint:** Message input must be responsive during streaming responses
- **Data Constraint:** All conversations must respect 10,000 limit
- **Export Constraint:** Markdown export must preserve full fidelity

**Task 1.4.1:** Enhance ChatView with message display and input
**Task 1.4.2:** Implement basic search in conversation list
**Task 1.4.3:** Implement Markdown export
**Task 1.4.4:** Implement StorageManager from Spec Section 1.6
**Task 1.4.5:** Implement RTL support
**Task 1.4.6 (Test):** Comprehensive widget and unit tests

**Validation Requirements:**
- Chat interface handles streaming responses
- Search filters work correctly
- Export produces valid Markdown
- Storage warnings appear at correct thresholds
- **Architectural Adherence Check:** Verify all UI updates go through state management

## Phase 2: Pro & Team Tiers - Cloud & Collaboration

### Sprint 2.1: User Authentication & Cloud Sync Foundation

#### Sprint Context & High-Level Directives
- **Overall Goal:** Integrate Firebase Auth and establish cloud sync foundation
- **Security Constraint:** All auth flows must handle errors gracefully
- **Sync Constraint:** Local-first; cloud sync is supplementary
- **Architecture Constraint:** Auth state managed via Riverpod only

**Task 2.1.1:** Build auth UI (Login, Sign-Up, Password Reset)
**Task 2.1.2:** Integrate Firebase Auth
**Task 2.1.3:** Create CloudConversationRepository
**Task 2.1.4:** Implement repository switching based on auth state
**Task 2.1.5:** Deploy Firestore security rules
**Task 2.1.6:** Create `firestore.indexes.json`:
```json
{
  "indexes": [
    {
      "collectionGroup": "conversations",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "updatedAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```
**Task 2.1.6.A (State Assertion):** Deploy indexes and verify with `firebase firestore:indexes`

**Validation Requirements:**
- Auth flows handle all edge cases
- Cloud sync maintains data integrity
- Security rules properly restrict access
- **Architectural Adherence Check:** No direct Firestore access outside repositories

### Sprint 2.2: Conflict Resolution UI

#### Sprint Context & High-Level Directives
- **Overall Goal:** Implement robust sync conflict resolution
- **UX Constraint:** Conflicts must be clearly explained to users
- **Data Constraint:** User choice must always be respected
- **Testing Constraint:** Simulate all conflict scenarios

**Task 2.2.1:** Implement conflict types from Spec Section 1.4
**Task 2.2.2:** Build conflict resolution dialog with diff viewer
**Task 2.2.3:** Create SyncService with periodic sync
**Task 2.2.4 (Test):** Test all conflict scenarios

**Validation Requirements:**
- Conflict UI clearly shows differences
- All resolution options work correctly
- No data loss during conflict resolution
- **Architectural Adherence Check:** Conflict resolution isolated from sync logic

### Sprint 2.3: Pro & Team Feature Implementation

#### Sprint Context & High-Level Directives
- **Overall Goal:** Implement feature gating and paid tier features
- **Business Constraint:** Feature gates must be server-authoritative
- **UX Constraint:** Locked features show clear upgrade path
- **Architecture Constraint:** Subscription state via provider only

**Task 2.3.1:** Implement SubscriptionService
**Task 2.3.2:** Create feature-gating provider
**Task 2.3.3:** Implement Team Workspaces
**Task 2.3.4:** Update security rules for organizations
**Task 2.3.5 (Test):** Test all subscription tiers

**Validation Requirements:**
- Feature gates work correctly
- Team features properly isolated
- Subscription changes apply immediately
- **Architectural Adherence Check:** No hardcoded feature checks

### Sprint 2.4: Feature Flags & A/B Testing

#### Sprint Context & High-Level Directives
- **Overall Goal:** Implement feature flag system for gradual rollouts
- **Architecture Constraint:** Flags must work offline with defaults
- **Testing Constraint:** All features must have flag override for testing
- **Performance Constraint:** Flag checks must be <1ms

**Task 2.4.1:** Integrate Firebase Remote Config
**Task 2.4.2:** Create FeatureFlagService
**Task 2.4.3:** Add sample flag implementation
**Task 2.4.4 (Test):** Test flag fallbacks and updates

**Validation Requirements:**
- Flags update without app restart
- Offline fallbacks work correctly
- Flag service is performant
- **Architectural Adherence Check:** No direct Remote Config access

## Phase 3: Enterprise & Compliance

### Sprint 3.0: Agentic Backend Implementation

#### Sprint Context & High-Level Directives
- **Overall Goal:** Implement serverless agent architecture
- **Cost Constraint:** Functions must have spending limits
- **Performance Constraint:** Cold starts must be <3s
- **Architecture Constraint:** Agents communicate via message queue only

**Task 3.0.1:** Implement categorizationAgent Cloud Function
```javascript
// functions/src/categorization-agent.ts
export const categorizationAgent = functions
  .runWith({
    memory: '512MB',
    timeoutSeconds: 60,
    maxInstances: 3
  })
  .firestore.document('conversations/{conversationId}/messages/{messageId}')
  .onCreate(async (snap, context) => {
    // Categorization logic
  });
```

**Task 3.0.2:** Add retry logic with exponential backoff
**Task 3.0.3:** Set up cost monitoring alerts
**Task 3.0.3.A (State Assertion):** Verify alert policy exists in Cloud Monitoring

**Validation Requirements:**
- Functions handle errors gracefully
- Retry logic prevents infinite loops
- Cost alerts trigger correctly
- **Architectural Adherence Check:** No synchronous agent calls from client

### Sprint 3.1: Enterprise Features

#### Sprint Context & High-Level Directives
- **Overall Goal:** Implement SSO and advanced audit logging
- **Security Constraint:** SSO must support standard SAML providers
- **Compliance Constraint:** Audit logs must be immutable
- **Performance Constraint:** Logging must not impact user operations

**Task 3.1.1:** Integrate SSO via Cloud Functions
**Task 3.1.2:** Create audit_logs subcollection
**Task 3.1.3:** Implement comprehensive audit logging
**Task 3.1.4:** Build audit log viewer UI
**Task 3.1.5 (Test):** Test SSO with mock provider

**Validation Requirements:**
- SSO works with major providers
- Audit logs capture all required events
- Log viewer has proper access controls
- **Architectural Adherence Check:** Audit logs write-only from client

### Sprint 3.2: Responsible AI Implementation

#### Sprint Context & High-Level Directives
- **Overall Goal:** Implement content moderation and safety features
- **Privacy Constraint:** PII detection must be client-side when possible
- **UX Constraint:** Moderation must not block legitimate use
- **Compliance Constraint:** Must meet EU AI Act requirements

**Task 3.2.1:** Implement PII detection
**Task 3.2.2:** Add malware URL scanning
**Task 3.2.3:** Create user control settings
**Task 3.2.4:** Label automated actions clearly
**Task 3.2.5 (Test):** Test moderation with edge cases

**Validation Requirements:**
- PII detection has low false positive rate
- URL scanning doesn't block legitimate sites
- User controls are respected
- **Architectural Adherence Check:** Moderation logic properly abstracted

### Sprint 3.3: Compliance Documentation

#### Sprint Context & High-Level Directives
- **Overall Goal:** Prepare compliance artifacts for enterprise sales
- **Legal Constraint:** Documents must be legally reviewed
- **Process Constraint:** Establish ongoing compliance workflows
- **Documentation Constraint:** All claims must be verifiable

**Task 3.3.1:** Draft GDPR DPIA document
**Task 3.3.2:** Create security.txt
**Task 3.3.3:** Begin SOC 2 gap analysis
**Task 3.3.4:** Finalize THIRD_PARTY_NOTICES.md

**Validation Requirements:**
- Documents are complete and accurate
- All dependencies properly attributed
- Security contact methods work
- **Architectural Adherence Check:** N/A (documentation sprint)

## Phase 4: Ecosystem & Market Launch

### Sprint 4.1: Browser Extension MVP

#### Sprint Context & High-Level Directives
- **Overall Goal:** Build minimal browser extension for Chrome
- **Security Constraint:** Request minimum necessary permissions
- **UX Constraint:** Extension must work on any webpage
- **Store Constraint:** Must pass Chrome Web Store review

**Task 4.1.1:** Create extension project structure
**Task 4.1.2:** Build context menu integration
**Task 4.1.3:** Document permission justifications
**Task 4.1.4:** Submit for unlisted review
**Task 4.1.4.A (State Assertion):** Verify submission status in Chrome Developer Dashboard

**Validation Requirements:**
- Extension works on test sites
- Permissions are justified
- No security vulnerabilities
- **Architectural Adherence Check:** Extension uses same API client as main app

### Sprint 4.2: Extension Marketplace

#### Sprint Context & High-Level Directives
- **Overall Goal:** Build infrastructure for third-party extensions
- **Security Constraint:** All extensions must be sandboxed
- **Review Constraint:** Clear SLAs for review process
- **Monetization Constraint:** Platform takes 30% of paid extensions

**Task 4.2.1:** Design Firestore schema for extensions
**Task 4.2.2:** Build admin review interface
**Task 4.2.3:** Set up automated security scanning
**Task 4.2.3.A (State Assertion):** Run test scan and verify results

**Validation Requirements:**
- Review interface is efficient
- Security scan catches known vulnerabilities
- Extension installation is smooth
- **Architectural Adherence Check:** Extensions cannot access user data directly

### Sprint 4.3: Final Launch Preparation

#### Sprint Context & High-Level Directives
- **Overall Goal:** Complete all pre-launch checklist items
- **Quality Constraint:** Zero P0 bugs
- **Performance Constraint:** All operations <5s
- **Scale Constraint:** Support 10x expected load

**Task 4.3.1:** Execute disaster recovery drill
**Task 4.3.2:** Perform load testing at 10x scale
**Task 4.3.3:** Record tutorial videos
**Task 4.3.4:** Staff support channels
**Task 4.3.5:** Final checklist review

**Validation Requirements:**
- DR plan executes successfully
- Load tests pass without degradation
- All documentation is complete
- Support channels are responsive
- **Architectural Adherence Check:** Final architecture review passes

## Rollback / Demo Artifacts (Simplified)

CI now publishes a single artifact bundle (`/build/reports/[commit_sha].zip`) containing:
- HTML test report & coverage
- Security / lint / perf summaries
- Optional MP4 demo (only for major UI sprints)

## Risk Register

| ID | Area | Likelihood | Impact | Mitigation | Owner |
|----|------|------------|--------|------------|-------|
| R-1 | Token cost spike | Medium | High | Spend alerts + kill-switch | Finance |
| R-2 | i18n rollout delay | High | Medium | Parallelize translation sprint | PM |
| R-3 | Extension rejection | Medium | High | Early review + compliance focus | Engineering |
| R-4 | Sync conflicts | High | Medium | Robust conflict UI + testing | Product |

## Enhanced Change Log and Version Control

### Required Commit Message Format
```
type(scope): brief description

[optional body explaining the change]

[optional footer with breaking changes, issues closed, etc.]

Examples:
feat(auth): add Firebase authentication integration
fix(chat): resolve message ordering issue
test(models): add comprehensive validation tests
docs(api): update conversation endpoint documentation
```

### Branch Strategy
```
main: Production-ready code only
develop: Integration branch for features
feature/[sprint-task]: Individual task branches
hotfix/[issue]: Critical production fixes
release/[version]: Release preparation
debug/[sprint-id]-failure: Debugging branches for stuck states
```

## Change Log

| Date (UTC) | Who | Summary |
|------------|-----|---------|
| 2025-06-10 | Copilot | Added design-system sprint, env management, DB migrations, indexing, observability, i18n/a11y, agentic backend, risk register |
| 2025-06-11 | Copilot | v3.0 – Added Sprint Context blocks, Architectural Adherence checks, escalation protocol, state assertion tasks, enhanced completion report |