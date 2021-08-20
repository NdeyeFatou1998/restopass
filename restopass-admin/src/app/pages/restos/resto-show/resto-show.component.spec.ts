import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RestoShowComponent } from './resto-show.component';

describe('RestoShowComponent', () => {
  let component: RestoShowComponent;
  let fixture: ComponentFixture<RestoShowComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RestoShowComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RestoShowComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
